# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2 check-reqs

# Notes: This is a preliminary ebuild of Eclipse-3.3
# It still has many QA problems (namely, we are still using a lot of bundled jars).
# Many things also still probably do not work in the IDE, but at least it loads.
# It was based on the initial ebuild in the gcj-overlay, so much of the credit goes out to geki.

# Tomcat is almost no longer needed in 3.3 and removed in 3.4.
# See bug: https://bugs.eclipse.org/bugs/show_bug.cgi?id=173692
# Currently we remove the Tomcat stuff entirely - potentially this can still break things.
# We'll put it back if there is any bug report, which is unlikely.

# To unbundle a jar, do the following:
# 1) Rewrite the ebuild so it uses OSGi packaging
# 2) Add the dependency and add it to gentoo_jars/system_jars
# 3) Remove it from the build directory, and don't forget to modify the Ant file
# so that it does *NOT* copy the file at the end

# Jetty and Tomcat-jasper jars have to stay bundled for now, until someone does some work on them.
# Hopefully, wltjr will soon package tomcat-jasper

DMF="R-${PV/.0}-200706251500"
MY_A="eclipse-sourceBuild-srcIncluded-${PV/.0}.zip"

DESCRIPTION="Eclipse Tools Platform"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download.eclipse.org/eclipse/downloads/drops/${DMF}/${MY_A}"

SLOT="3.3"
LICENSE="EPL-1.0"
IUSE="doc"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}
PATCHDIR="${FILESDIR}/${SLOT}"
FEDORA="${PATCHDIR}/fedora"
ECLIPSE_DIR="/usr/lib/eclipse-${SLOT}"

CDEPEND=">=dev-java/ant-eclipse-ecj-3.3
	dev-java/ant-core
	dev-java/ant-nodeps
	>=dev-java/swt-${SLOT}-r1
	=dev-java/junit-3*
	=dev-java/junit-4*
	>=dev-java/jsch-0.1.34-r1
	>=dev-java/icu4j-3.6.1
	>=dev-java/commons-el-1.0-r2
	>=dev-java/commons-logging-1.1-r3
	=dev-java/tomcat-servlet-api-5.5.25-r1"
#	>=www-servers/jetty-5.1"
	
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
	
DEPEND="=virtual/jdk-1.5*
	sys-apps/findutils
	dev-java/sun-j2me-bin
	app-arch/unzip
	app-arch/zip
	${CDEPEND}"
		
#	=dev-java/lucene-2.2*
#	=dev-java/lucene-analyzers-2.2*

JAVA_PKG_BSFIX="off"

pkg_setup() {
	java-pkg-2_pkg_setup

	CHECKREQS_MEMORY="768"
	check_reqs

	eclipse_arch=${ARCH}
	use amd64 && eclipse_arch="x86_64"
}

src_unpack() {
	unpack ${A}
	patch-apply
	remove-bundled-stuff

	# No warnings / java5 / all output should be directed to stdout
	find ${S} -type f -name '*.xml' -exec \
		sed -r -e "s:(-encoding ISO-8859-1):\1 -nowarn:g" -e "s:(\"compilerArg\" value=\"):\1-nowarn :g" \
			-e "s:(<property name=\"javacSource\" value=)\".*\":\1\"1.5\":g" \
			-e "s:(<property name=\"javacTarget\" value=)\".*\":\1\"1.5\":g" -e "s:output=\".*(txt|log).*\"::g" -i {} \;

	# JDK home
	sed -r -e "s:^(JAVA_HOME =) .*:\1 $(java-config --jdk-home):" -e "s:gcc :gcc ${CFLAGS} :" \
		-i plugins/org.eclipse.core.filesystem/natives/unix/linux/Makefile \
		|| die "sed Makefile failed"

	while read line; do
		java-ant_rewrite-classpath "$line" > /dev/null
    done < <(find ${S} -type f -name "build.xml" )
}

src_compile() {
	# Figure out correct boot classpath
	local bootclasspath=$(java-config --runtime)
	einfo "Using bootclasspath ${bootclasspath}"

	java-pkg_force-compiler ecj-3.3
	
	# system_jars will be used when compiling (javac)
	# gentoo_jars will be used when building JSPs and other ant tasks (not javac)
	
	local system_jars="$(java-pkg_getjars swt-3,icu4j-3.6,ant-core,jsch,ant-nodeps,junit-4,tomcat-servlet-api-2.4):$(java-pkg_getjars --build-only sun-j2me-bin)"
	local gentoo_jars="$(java-pkg_getjars ant-core,icu4j-3.6,jsch,commons-logging,commons-el,tomcat-servlet-api-2.4)"
	local options="-q -Dnobootstrap=true -Dlibsconfig=true -Dbootclasspath=${bootclasspath} -DinstallOs=linux \
	-DinstallWs=gtk -DinstallArch=${eclipse_arch} -Djava5.home=$(java-config --jdk-home)"
	
	use doc && options="${options} -Dgentoo.javadoc=true"
	
	ANT_OPTS=-Xmx1024M ANT_TASKS="ant-nodeps" eant ${options} -Dgentoo.classpath="${system_jars}" -Dgentoo.jars="${gentoo_jars//:/,}"
}

src_install() {
	dodir /usr/lib

	[[ -f result/linux-gtk-${eclipse_arch}-sdk.tar.gz ]] || die "tar.gz bundle was not built properly!"
	tar zxf "result/linux-gtk-${eclipse_arch}-sdk.tar.gz" -C "${D}/usr/lib" || die "Failed to extract the built package"

	mv "${D}/usr/lib/eclipse" "${D}/${ECLIPSE_DIR}"

	# The following moves the loader and built shared libraries to the correct place
	
	mv "${S}/launchertmp/eclipse" "${D}/${ECLIPSE_DIR}"
	mv ${S}/launchertmp/library/gtk/eclipse_*.so ${D}/${ECLIPSE_DIR}/plugins/org.eclipse.equinox.launcher.gtk.linux.*/

	# Install startup script
	exeinto /usr/bin
	doexe "${FILESDIR}/${SLOT}/eclipse-${SLOT}"
	
	# Install eclipse configuration file.	
	cat > "${D}/${ECLIPSE_DIR}/eclipse.ini" <<-EOF
-showsplash
org.eclipse.platform
-vmargs
-Djava.library.path=/usr/lib
-Xms128m
-Xmx256m
EOF

	make_desktop_entry eclipse-${SLOT} "Eclipse ${PV}" "${ECLIPSE_DIR}/icon.xpm"

	cd "${D}/${ECLIPSE_DIR}"
	install-link-system-jars
}

pkg_postinst() {
	einfo
	einfo "Welcome to Eclipse-3.3 (Europa)!"
	einfo
	einfo "You can now install plugins via Update Manager without any"
	einfo "tweaking. This is the recommended way to install new features for Eclipse."
	einfo
	einfo "If your Eclipse install seems slow, and is unstable,"
	einfo "read (especially if you are on amd64 or use a lot of plugins):"
	einfo "file://${ECLIPSE_DIR}/readme/readme_eclipse.html#Running%20Eclipse"
	einfo "about memory issues (modify ${ECLIPSE_DIR}/eclipse.ini)"
}

# -----------------------------------------------------------------------------
#  Helper functions
# -----------------------------------------------------------------------------

install-link-system-jars() {

	pushd plugins/ > /dev/null
	java-pkg_jarfrom swt-3
	
	mkdir "org.apache.ant"
	mkdir "org.apache.ant/META-INF/"
	mkdir "org.apache.ant/lib"
	cp "${FILESDIR}/${SLOT}/ant-osgi-manifest.mf" "org.apache.ant/META-INF/MANIFEST.MF"
	pushd org.apache.ant/lib > /dev/null
	java-pkg_jarfrom ant-core
	java-pkg_jarfrom ant-nodeps	
	popd > /dev/null

	java-pkg_jarfrom icu4j-3.6
	java-pkg_jarfrom jsch
	java-pkg_jarfrom commons-el
	java-pkg_jarfrom commons-logging

	popd > /dev/null

	pushd plugins/org.junit_*/ > /dev/null
	java-pkg_jarfrom junit
	popd > /dev/null

	pushd plugins/org.junit4*/ > /dev/null
	java-pkg_jarfrom junit-4
	popd > /dev/null
}


symlink-lucene() {
	pushd plugins/ > /dev/null
	local lucene_jar="$(basename org.apache.lucene_*.jar)"
	local lucene_analysis_jar="$(basename org.apache.lucene.analysis_*.jar)"
	rm ${lucene_jar} ${lucene_analysis_jar}
	java-pkg_jar-from lucene-2 lucene.jar ${lucene_jar}
	java-pkg_jar-from lucene-analyzers-2 lucene-analyzers.jar ${lucene_analysis_jar}
	popd > /dev/null
}

patch-apply() {
	# Patch launcher source
	mkdir launchertmp
	unzip -qq -d launchertmp plugins/org.eclipse.platform/launchersrc.zip > /dev/null || die "unzip failed"
	pushd launchertmp/ > /dev/null
	epatch "${PATCHDIR}/launcher_double-free.diff"
	sed -i "s/CFLAGS\ =\ -O\ -s\ -Wall/CFLAGS = ${CFLAGS}\ -Wall/" library/gtk/make_linux.mak \
		|| die "Failed to tweak make_linux.mak"
	zip -q -6 -r ../launchersrc.zip * >/dev/null || die "zip failed"
	popd > /dev/null
	mv launchersrc.zip plugins/org.eclipse.platform/launchersrc.zip
	rm -rf launchertmp

	# Disable SWT, jdk6 eclipse-3.3-features-platform-build.xml.diff
	epatch "${PATCHDIR}/disable-swt.diff" # this patch disables SWT
	epatch "${PATCHDIR}/disable-jdt-tool.diff"
	epatch "${PATCHDIR}/disable-jdk6.diff"
	epatch "${PATCHDIR}/set-java-home.diff" # this setups the java5 home variable

	#epatch "${FILESDIR}/${SLOT}/${P}-buildJSPs.patch"
	#cp "${FILESDIR}/${SLOT}/buildJSPs.xml" "plugins/org.eclipse.help.webapp/buildJSPs.xml"
	#cp "${FILESDIR}/${SLOT}/build-isv.xml" "plugins/org.eclipse.platform.doc.isv/build.xml"
		
	cp "${FILESDIR}/${SLOT}/isv-build.xml" "plugins/org.eclipse.help.webapp/build.xml" # this adds a path for building
	cp "${FILESDIR}/${SLOT}/buildDoc.xml" "plugins/org.eclipse.platform.doc.isv/buildDoc.xml" # this adds a path for building
	cp "${FILESDIR}/${SLOT}/build-platform.xml" "features/org.eclipse.platform/build.xml" # this essentially disables Tomcat
	cp "${FILESDIR}/${SLOT}/build-platform-source.xml" "plugins/org.eclipse.platform.source/build.xml" # this essentially disables Tomcat
	cp "${FILESDIR}/${SLOT}/build-osgi-services.xml" "plugins/org.eclipse.osgi.services/build.xml" # this unknown
	cp "${FILESDIR}/${SLOT}/build-osgi-util.xml" "plugins/org.eclipse.osgi.util/build.xml" # this unknown
		
	epatch "${FEDORA}/eclipse-libupdatebuild2.patch" # JNI

	# Fedora does not apply this anymore because they checkout
	# org.eclipse.equinox.initializer project from cvs. Untill a fix, we'll
	# keep the old patch
	pushd plugins/org.eclipse.core.runtime >/dev/null
	epatch "${FEDORA}/eclipse-fileinitializer.patch"
	popd >/dev/null

	# Generic releng plugins that can be used to build plugins
	# https://www.redhat.com/archives/fedora-devel-java-list/2006-April/msg00048.html
	pushd plugins/org.eclipse.pde.build > /dev/null
	# Patch 53
	epatch "${FEDORA}/eclipse-pde.build-add-package-build.patch"
	sed -e "s:@eclipse_base@:${ECLIPSE_DIR}:g" -i templates/package-build/build.properties
	popd > /dev/null

	# Later we could produce a patch out of these, but this is not the best solution
	# since this would make a lot of patches (x86, x86_64...)

	sed -i "s/<copy.*com\.jcraft\.jsch.*\/>//" "package.org.eclipse.sdk.linux.gtk.${eclipse_arch}.xml"
	sed -i "s/<copy.*com\.ibm\.icu.*\/>//" "package.org.eclipse.sdk.linux.gtk.${eclipse_arch}.xml"
	sed -i "s/<copy.*org\.apache\.commons\.el_.*\/>//" "package.org.eclipse.sdk.linux.gtk.${eclipse_arch}.xml"
	sed -i "s/<copy.*org\.apache\.commons\.logging_.*\/>//" "package.org.eclipse.sdk.linux.gtk.${eclipse_arch}.xml"
	sed -i "s/<copy.*javax\.servlet\.jsp_.*\/>//" "package.org.eclipse.sdk.linux.gtk.${eclipse_arch}.xml"
	sed -i "s/<copy.*javax\.servlet_.*\/>//" "package.org.eclipse.sdk.linux.gtk.${eclipse_arch}.xml"
	
	sed -i "/^.*<ant.*org\.eclipse\.tomcat.*/{N;N;d;}" "assemble.org.eclipse.sdk.linux.gtk.${eclipse_arch}.xml"
}

remove-bundled-stuff() {
	# Remove pre-built eclipse binaries
	find ${S} -type f -name eclipse | xargs rm
	# ...  .so libraries
	find ${S} -type f -name '*.so' | xargs rm
	# ... .jar files
	rm plugins/org.eclipse.swt/extra_jars/exceptions.jar \
		plugins/org.eclipse.osgi/osgi/osgi*.jar \
		plugins/org.eclipse.osgi/supplement/osgi/osgi.jar
		
	rm -rf plugins/org.eclipse.swt.*
	rm -rf plugins/org.apache.ant_*
	rm plugins/org.apache.commons.*.jar
	rm plugins/com.jcraft.jsch*
	rm plugins/com.ibm.icu*
	rm plugins/org.junit_*/*.jar
	rm plugins/org.junit4*/*.jar
	rm plugins/javax.*.jar
	
	# mv junit* junit3 -> do this
	
	rm -rf "plugins/org.eclipse.osgi.services/org"
	#mkdir "plugins/org.eclipse.osgi.services/src/"
	unzip -q "plugins/org.eclipse.osgi.services/src.zip" -d "plugins/org.eclipse.osgi.services/"
	rm -rf "plugins/org.eclipse.osgi.util/org"
	#mkdir "plugins/org.eclipse.osgi.util/src/"	
	unzip -q "plugins/org.eclipse.osgi.util/src.zip" -d "plugins/org.eclipse.osgi.util/"
	
	# Removing Tomcat stuff
	
	rm -rf "plugins/org.eclipse.tomcat/"
}

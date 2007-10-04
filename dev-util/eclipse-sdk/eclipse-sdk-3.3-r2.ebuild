# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2 check-reqs

# Notes: This is a preliminary *working* ebuild of Eclipse-3.3
# It still has many QA problems (namely, we are still using a lot of bundled jars).
# Many things also still probably do not work in the IDE, but at least it loads.
# It was based on the initial ebuild in the gcj-overlay, so much of the credit goes out to geki.



DMF="R-${PV/.0}-200706251500"
MY_A="eclipse-sourceBuild-srcIncluded-${PV/.0}.zip"

DESCRIPTION="Eclipse Tools Platform"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download.eclipse.org/eclipse/downloads/drops/${DMF}/${MY_A}"

SLOT="3.3"
LICENSE="EPL-1.0"
IUSE="branding tomcat"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}
PATCHDIR=${FILESDIR}/${SLOT}
FEDORA=${PATCHDIR}/fedora
ECLIPSE_DIR="/usr/lib/eclipse-${SLOT}"

CDEPEND=">=dev-java/ant-eclipse-ecj-3.3
	>=dev-java/ant-core-1.7.0-r1
	tomcat? (
		dev-java/commons-digester-rss
		=dev-java/mx4j-core-3*
		=dev-java/jakarta-regexp-1.4*
		=dev-java/servletapi-2.4*
		>=www-servers/tomcat-5.5.17
	)
	>=dev-java/swt-${SLOT}-r1
	=dev-java/junit-3*
	=dev-java/junit-4*
	>=dev-java/jsch-0.1.34-r1"
	
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
DEPEND="=virtual/jdk-1.5*
	dev-java/ant-nodeps
	${CDEPEND}
	>=sys-apps/findutils-4.1.7
	app-arch/unzip
	app-arch/zip"
#	=dev-java/lucene-2.2*
#	=dev-java/lucene-analyzers-2.2*

JAVA_PKG_BSFIX="off"

pkg_setup() {
	java-pkg-2_pkg_setup

	CHECKREQS_MEMORY="768"
	check_reqs

	eclipse_arch=${ARCH}
	use amd64 && eclipse_arch=x86_64
}

src_unpack() {
	unpack ${A}

	patch-apply

	# Remove pre-built eclipse binaries
	find ${S} -type f -name eclipse | xargs rm
	# ...  .so libraries
	find ${S} -type f -name '*.so' | xargs rm
	# ... .jar files
	rm plugins/org.eclipse.swt/extra_jars/exceptions.jar \
		plugins/org.eclipse.osgi/osgi/osgi*.jar \
		plugins/org.eclipse.osgi/supplement/osgi/osgi.jar
		
	rm -rf plugins/org.eclipse.swt.*

	# no warnings / java5 / all output should be directed to stdout
	find ${S} -type f -name '*.xml' -exec \
		sed -r -e "s:(-encoding ISO-8859-1):\1 -nowarn:g" \
			-e "s:(\"compilerArg\" value=\"):\1-nowarn :g" \
			-e "s:(<property name=\"javacSource\" value=)\".*\":\1\"1.5\":g" \
			-e "s:(<property name=\"javacTarget\" value=)\".*\":\1\"1.5\":g" \
			-e "s:output=\".*(txt|log).*\"::g" -i {} \;

	# JDK home
	sed -r -e "s:^(JAVA_HOME =) .*:\1 $(java-config --jdk-home):" \
		-e "s:gcc :gcc ${CFLAGS} :" \
		-i plugins/org.eclipse.core.filesystem/natives/unix/linux/Makefile \
		|| die "sed makefile failed"

	ebegin "Symlinking system jars"
		symlink-ant
		symlink-junit
		symlink-jsch
#		symlink-lucene		
		use tomcat && symlink-tomcat
	eend $?
	
	while read line; do
		java-ant_rewrite-classpath "$line"
    done < <(find ${S} -type f -name 'build.xml' )
}

src_compile() {
	# Figure out correct boot classpath
	local bootclasspath=$(java-config --runtime)
	einfo "Using bootclasspath ${bootclasspath}"

	java-pkg_force-compiler ecj-3.3
	ANT_OPTS=-Xmx1024M \
		eant -q -Dnobootstrap=true -Dlibsconfig=true -Dbootclasspath=${bootclasspath} \
		-DinstallOs=linux -DinstallWs=gtk -DinstallArch=${eclipse_arch} \
		-Djava5.home=$(java-config --jdk-home) -Dgentoo.classpath=`java-pkg_getjars swt-3`
}

src_install() {
	dodir /usr/lib

	[[ -f result/linux-gtk-${eclipse_arch}-sdk.tar.gz ]] \
		|| die "tar.gz bundle was not built properly!"
	tar zxf result/linux-gtk-${eclipse_arch}-sdk.tar.gz -C ${D}/usr/lib \
		|| die "Failed to extract the built package"

	mv ${D}/usr/lib/eclipse ${D}/${ECLIPSE_DIR}

	# What does this do?
	
	mv ${S}/launchertmp/eclipse ${D}/${ECLIPSE_DIR}
	mv ${S}/launchertmp/library/gtk/eclipse_*.so ${D}/${ECLIPSE_DIR}/plugins/org.eclipse.equinox.launcher.gtk.linux.*/

	# Install startup script
	exeinto /usr/bin
	doexe ${FILESDIR}/eclipse-${SLOT}
	echo "-Xss2048k" >> ${D}/${ECLIPSE_DIR}/eclipse.ini

	make_desktop_entry eclipse-${SLOT} "Eclipse ${PV}" "${ECLIPSE_DIR}/icon.xpm"

	cd ${D}/${ECLIPSE_DIR}
	install-link-system-jars
}

pkg_postinst() {
	einfo
	einfo "Users can now install plugins via Update Manager without any"
	einfo "tweaking."
	einfo
	einfo "Eclipse plugin packages (ie eclipse-cdt) will likely go away in"
	einfo "the near future until they can be properly packaged. Update Manager"
	einfo "is prefered in the meantime."
	einfo
	einfo "If you plan to use heavy plugins, mind to read"
	einfo "file://${ECLIPSE_DIR}/readme/readme_eclipse.html#Running%20Eclipse"
	einfo "about memory issues"
	einfo "(and to eventually modify ${ECLIPSE_DIR}/eclipse.ini)"
	einfo

	if use gcj ; then
		rm -f /usr/lib/eclipse-${ECLIPSE_VER}/eclipse.gcjdb
		${FILESDIR}/build-eclipse-classmap ${SLOT}
	fi
}

# -----------------------------------------------------------------------------
#  Helper functions
# -----------------------------------------------------------------------------

install-link-system-jars() {
	#local ant_dir="$(basename plugins/org.apache.ant_*)"
	#dosym /usr/share/ant-core ${ECLIPSE_DIR}/plugins/${ant_dir}

	pushd plugins/	
	rm -rf org.apache.ant_*
	java-pkg_jarfrom swt-3
	java-pkg_jarfrom ant-core	
	popd

#	symlink-lucene
	symlink-junit
	symlink-jsch
	use tomcat && symlink-tomcat
}

symlink-ant() {
	pushd plugins/org.apache.ant_*/lib/
	rm *.jar
	java-pkg_jarfrom ant-core
	java-pkg_jarfrom --build-only ant-nodeps
	popd
}

symlink-tomcat() {
	pushd plugins/org.eclipse.tomcat*/
	rm *.jar
	mkdir lib
	pushd lib/

	java-pkg_jarfrom tomcat-5.5
	java-pkg_jarfrom mx4j-core-3.0
	java-pkg_jarfrom commons-beanutils-1.7
	java-pkg_jarfrom commons-collections
	java-pkg_jarfrom commons-dbcp
	java-pkg_jarfrom commons-digester
	java-pkg_jarfrom commons-digester-rss
	java-pkg_jarfrom commons-el
	java-pkg_jarfrom commons-fileupload
	java-pkg_jarfrom commons-launcher
	java-pkg_jarfrom commons-logging
	java-pkg_jarfrom commons-modeler
	java-pkg_jarfrom commons-pool
	java-pkg_jarfrom servletapi-2.4 servlet-api.jar servletapi5.jar
	java-pkg_jarfrom servletapi-2.4 jsp-api.jar jspapi.jar
	java-pkg_jarfrom jakarta-regexp-1.4
	ln -s /usr/share/tomcat-5.5/bin/bootstrap.jar bootstrap.jar
	popd
	popd
}

symlink-lucene() {
	pushd plugins/
	local lucene_jar="$(basename org.apache.lucene_*.jar)"
	local lucene_analysis_jar="$(basename org.apache.lucene.analysis_*.jar)"
	rm ${lucene_jar} ${lucene_analysis_jar}
	java-pkg_jar-from lucene-2 lucene.jar ${lucene_jar}
	java-pkg_jar-from lucene-analyzers-2 lucene-analyzers.jar ${lucene_analysis_jar}
	popd
}

symlink-junit() {
	pushd plugins/org.junit_*/
	rm *.jar
	java-pkg_jarfrom junit
	popd

	pushd plugins/org.junit4*/
	rm *.jar
	java-pkg_jarfrom junit-4
	popd
}

symlink-jsch() {
	pushd plugins/
	local jsch_jar="$(basename com.jcraft.jsch_*.jar)"
	rm ${jsch_jar}
	java-pkg_jar-from jsch jsch.jar ${jsch_jar}
	popd
}

patch-apply() {
	# patch launcher source
	mkdir launchertmp
	unzip -qq -d launchertmp plugins/org.eclipse.platform/launchersrc.zip >/dev/null || die "unzip failed"
	pushd launchertmp/
	epatch ${PATCHDIR}/launcher_double-free.diff
	sed -i "s/CFLAGS\ =\ -O\ -s\ -Wall/CFLAGS = ${CFLAGS}\ -Wall/" \
		library/gtk/make_linux.mak \
		|| die "Failed to tweak make_linux.mak"
	zip -q -6 -r ../launchersrc.zip * >/dev/null || die "zip failed"
	popd
	mv launchersrc.zip plugins/org.eclipse.platform/launchersrc.zip
	rm -rf launchertmp

	# disable swt, jdk6
	epatch ${PATCHDIR}/eclipse_disable-swt.diff
	epatch ${PATCHDIR}/eclipse_disable-jdt-tool.diff
	epatch ${PATCHDIR}/eclipse_disable-jdk6.diff

	# What does this do?
	epatch ${PATCHDIR}/how_to_loose_sanity_on_freaky_env_vars_argh.diff

	# JNI
	epatch ${FEDORA}/eclipse-libupdatebuild2.patch

	# Fedora does not apply this anymore because they checkout
	# org.eclipse.equinox.initializer project from cvs. 'till a fix, we'll
	# keep the old patch
	pushd plugins/org.eclipse.core.runtime >/dev/null
	epatch ${FEDORA}/eclipse-fileinitializer.patch
	popd >/dev/null

	# TOMCAT
	if use tomcat; then
		pushd plugins/org.eclipse.tomcat >/dev/null || die "pushd failed"
		# %patch28 -p0
		epatch ${FEDORA}/eclipse-tomcat55.patch
		# %patch29 -p0
		epatch ${FEDORA}/eclipse-tomcat55-build.patch
		popd >/dev/null

		sed -e "s/4.1.130/5.5.17/g" \
			-i features/org.eclipse.platform/build.xml \
			-i plugins/org.eclipse.tomcat/build.xml    \
			-i assemble.*.xml
	fi

	# generic releng plugins that can be used to build plugins
	# https://www.redhat.com/archives/fedora-devel-java-list/2006-April/msg00048.html
	pushd plugins/org.eclipse.pde.build >/dev/null
	# %patch53
	epatch ${FEDORA}/eclipse-pde.build-add-package-build.patch
	sed -e "s:@eclipse_base@:${ECLIPSE_DIR}:g" \
		-i templates/package-build/build.properties
	popd >/dev/null

	# BRANDING
# FIXME link?
#	if use branding; then
#		pushd plugins/org.eclipse.platform >/dev/null
#		cp ${WORKDIR}/splash.bmp .
#		popd >/dev/null
#	fi
}

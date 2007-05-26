# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/netbeans/netbeans-5.5-r4.ebuild,v 1.1 2007/01/28 19:40:16 fordfrog Exp $

# TODO:
# - bind dependencies to USE flags
# - during src_compile nbbuild/build.xml downloads jsr223-api.jar so get rid of this download
# - now 'apisupport' is included in the unconditional section of SRC_URI though it is not needed by platform but
#   at this moment I do not know how to build platform without harness as trying to build it causes error on
#   xerces which I do not know how to solve - once it is solved apisupport can be removed from the unconditional section
# - now 'ide' is included in 'harness' SRC_URI as it is needed during compilation though not mentioned
#   in cluster properties

WANT_SPLIT_ANT=true
inherit eutils java-pkg-2 java-ant-2 versionator

DESCRIPTION="NetBeans IDE for Java"
HOMEPAGE="http://www.netbeans.org"

SLOT="6.0"
MILESTONE="m9"
MY_PV=${PV/_alpha/-m}
SOURCE_SITE="http://dev.gentoo.org/~fordfrog/distfiles/"
SRC_URI="
	${SOURCE_SITE}/${PN}-apisupport-${MY_PV}.tar.bz2
	${SOURCE_SITE}/${PN}-autoupdate-${MY_PV}.tar.bz2
	${SOURCE_SITE}/${PN}-core-${MY_PV}.tar.bz2
	${SOURCE_SITE}/${PN}-editor-${MY_PV}.tar.bz2
	${SOURCE_SITE}/${PN}-graph-${MY_PV}.tar.bz2
	${SOURCE_SITE}/${PN}-libs-${MY_PV}.tar.bz2
	${SOURCE_SITE}/${PN}-nbbuild-${MY_PV}.tar.bz2
	${SOURCE_SITE}/${PN}-openide-${MY_PV}.tar.bz2
	${SOURCE_SITE}/${PN}-projects-${MY_PV}.tar.bz2
	apisupport? (
		${SOURCE_SITE}/${PN}-apisupport-${MY_PV}.tar.bz2
	)
	harness? (
		${SOURCE_SITE}/${PN}-apisupport-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-ide-${MY_PV}.tar.bz2
	)
	ide? (
		${SOURCE_SITE}/${PN}-apisupport-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-classfile-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-db-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-debuggercore-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-diff-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-extbrowser-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-html-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-httpserver-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-ide-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-image-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-javacvs-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-languages-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-lexer-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-openidex-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-properties-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-refactoring-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-schema2beans-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-scripting-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-subversion-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-usersguide-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-utilities-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-versioncontrol-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-web-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-xml-${MY_PV}.tar.bz2
	)
	j2ee? (
		${SOURCE_SITE}/${PN}-j2ee-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-j2eeserver-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-monitor-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-serverplugins-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-web-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-websvc-${MY_PV}.tar.bz2
	)
	java? (
		${SOURCE_SITE}/${PN}-ant-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-db-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-debuggerjpda-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-form-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-i18n-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-j2ee-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-java-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-javadoc-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-javawebstart-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-junit-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-refactoring-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-usersguide-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-websvc-${MY_PV}.tar.bz2
	)
	mobility? (
		${SOURCE_SITE}/${PN}-mobility-${MY_PV}.tar.bz2
	)
	nb? (
		${SOURCE_SITE}/${PN}-ide-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-logger-${MY_PV}.tar.bz2
	)
	profiler? (
		${SOURCE_SITE}/${PN}-debuggerjpda-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-profiler-${MY_PV}.tar.bz2
	)
	ruby? (
		${SOURCE_SITE}/${PN}-languages-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-scripting-${MY_PV}.tar.bz2
	)
	soa? (
		${SOURCE_SITE}/${PN}-enterprise-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-identity-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-print-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-xml-${MY_PV}.tar.bz2
	)
	testtools? (
		${SOURCE_SITE}/${PN}-jellytools-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-jemmy-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-jemmysupport-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-xtest-${MY_PV}.tar.bz2
	)
	uml? (
		${SOURCE_SITE}/${PN}-uml-${MY_PV}.tar.bz2
	)
	visualweb? (
		${SOURCE_SITE}/${PN}-db-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-visualweb-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-web-${MY_PV}.tar.bz2
	)"

LICENSE="CDDL"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="apisupport debug doc harness ide j2ee java mobility nb profiler ruby soa testtools uml visualweb"

#COMMON_DEPEND="
#	>=dev-java/ant-1.7.0
#	dev-java/antlr
#	=dev-java/commons-beanutils-1.7*
#	dev-java/commons-collections
#	>=dev-java/commons-logging-1.0.4
#	dev-java/flute
#	>=dev-java/jakarta-jstl-1.1.2
#	>=dev-java/javahelp-2.0.02
#	>=dev-java/jsch-0.1.24
#	=dev-java/junit-3.8*
#	>=dev-java/junit-4
#	dev-java/sac
#	=dev-java/servletapi-2.2*
#	>=dev-java/sun-j2ee-deployment-bin-1.1
#	=dev-java/swing-layout-1*
#	>=dev-java/xerces-2.8.1
#	>=dev-java/xml-commons-1.0_beta2
#	mobility? (
#		dev-java/commons-httpclient
#		dev-java/commons-net
#		dev-java/proguard
#	)
#	visualweb? (
#		dev-java/commons-digester
#		dev-java/commons-fileupload
#	)
#"

#RDEPEND=">=virtual/jre-1.5
#	dev-java/commons-digester
#	>=dev-java/commons-fileupload-1.1
#	>=dev-java/commons-io-1.2
#	dev-java/commons-validator
#	dev-java/fastinfoset
#	dev-java/jakarta-oro
#	dev-java/jax-rpc
#	dev-java/jax-ws
#	dev-java/jax-ws-api
#	>=dev-java/jaxb-2
#	>dev-java/jaxb-tools-2
#	dev-java/jaxp
#	mobility? ( >=dev-java/jdom-1.0 )
#	dev-java/jsr67
#	dev-java/jsr101
#	dev-java/jsr173
#	dev-java/jsr181
#	dev-java/jsr250
#	=dev-java/struts-1.2*
#	dev-java/relaxng-datatype
#	dev-java/saaj
#	dev-java/sjsxp
#	dev-java/sun-jaf
#	dev-java/sun-javamail
#	dev-java/xsdlib
#	${COMMON_DEPEND}"

# NOTE: Currently there is a problem with building netbeans and mobility pack with JDK 1.6
# so we limit it to JDK 1.5 for now.
#DEPEND="=virtual/jdk-1.5*
#	>=dev-java/commons-cli-1.0
#	dev-java/commons-el
#	>=dev-java/commons-jxpath-1.1
#	>=dev-java/commons-lang-2.1
#	dev-java/glassfish-persistence
#	dev-java/ical4j
#	mobility? ( dev-java/jakarta-oro )
#	>=dev-java/jcalendar-1.2
#	>=dev-java/jdom-1.0
#	>=dev-java/jmi-interface-1.0-r3
#	dev-java/jtidy
#	>=dev-java/prefuse-20060715_beta
#	>=dev-java/rome-0.6
#	=dev-java/servletapi-2.3*
#	dev-java/sun-jmx
#	>=dev-java/xml-xmlbeans-1.0.4
#	dev-util/checkstyle
#	>=dev-util/pmd-1.3
#	${COMMON_DEPEND}"

COMMON_DEPEND="
	>=dev-java/javahelp-2.0.02
	=dev-java/swing-layout-1*"

RDEPEND=">=virtual/jdk-1.5
	>=dev-java/javahelp-2.0.02
	=dev-java/swing-layout-1*
	java? ( >=dev-java/ant-tasks-1.7.0-r2 )
	${COMMON_DEPEND}"

DEPEND="=virtual/jdk-1.5*
	>=dev-java/ant-nodeps-1.7.0
	>=dev-java/javahelp-2.0.02
	=dev-java/swing-layout-1*
	testtools? ( >=dev-java/ant-trax-1.7.0 )
	visualweb? ( >=dev-java/xerces-2.9.0 )
	${COMMON_DEPEND}"

S=${WORKDIR}/netbeans-src
BUILDDESTINATION="${S}/nbbuild/netbeans"
ENTERPRISE="4"
IDE_VERSION="8"
PLATFORM="7"
MY_FDIR="${FILESDIR}/${SLOT}"
DESTINATION="/usr/share/netbeans-${SLOT}"
JAVA_PKG_BSFIX="off"

pkg_setup() {
	if use apisupport && ( ! use ide || ! use java ) ; then
		eerror "'apisupport' USE flag requires 'ide' and 'java' USE flags"
		exit 1
	fi

	if use j2ee && ( ! use ide || ! use java ) ; then
		eerror "'j2ee' USE flag requires 'ide' and 'java' USE flags"
		exit 1
	fi

	if use java && ! use ide ; then
		eerror "'java' USE flag requires 'ide' USE flag"
		exit 1
	fi

	if use mobility && ( ! use ide || ! use java ) ; then
		eerror "'mobility' USE flag requires 'ide' and 'java' USE flags"
		exit 1
	fi

	if use nb && ! use ide ; then
		eerror "'nb' USE flag requires 'ide' USE flag"
		exit 1
	fi

	if use profiler && ! use j2ee ; then
		eerror "'profiler' USE flag requires 'j2ee' USE flag"
		exit 1
	fi

	if use ruby && ! use ide ; then
		eerror "'ruby' USE flag requires 'ide' USE flag"
		exit 1
	fi

	if use soa && ( ! use ide || ! use java || ! use j2ee ) ; then
		eerror "'soa' USE flag requires 'ide', 'java' and 'j2ee' USE flags"
		exit 1
	fi

	if use testtools && ! use ide ; then
		eerror "'testtools' USE flag requires 'ide' USE flag"
		exit 1
	fi

	if use uml && ( ! use ide || ! use java ) ; then
		eerror "'uml' USE flag requires 'ide' and 'java' USE flags"
		exit 1
	fi

	if use visualweb && ( ! use ide || ! use java || ! use j2ee ) ; then
		eerror "'visualweb' USE flag requires 'ide', 'java' and 'j2ee' USE flags"
		exit 1
	fi

	java-pkg-2_pkg_setup
}

src_unpack () {
	unpack ${A}

	# Clean up nbbuild
	einfo "Removing prebuilt *.class files from nbbuild"
	find ${S}/nbbuild -name "*.class" -delete

	# Disable the bundled Tomcat in favor of Portage installed version
	einfo "Disabling bundled Tomcat"
	sed -i -e "s%tomcatint/tomcat5,\\\\%%g" ${S}/nbbuild/cluster.properties || die "Cannot disable bundled Tomcat"

	# Remove JARs that are not needed
	einfo "Removing not needed JARs"
	for FILE in `find ${S} -name "*.jar" | grep "/test/"`; do
		rm -v ${FILE} || die "Cannot remove ${FILE}"
	done

	place_unpack_symlinks
}

src_compile() {
	local antflags="-Dstop.when.broken.modules=true -Ddo-not-rebuild-clusters=true"

	if use debug; then
		antflags="${antflags} -Dbuild.compiler.debug=true"
		antflags="${antflags} -Dbuild.compiler.deprecation=true"
	else
		antflags="${antflags} -Dbuild.compiler.deprecation=false"
	fi

	local clusters="-Dnb.clusters.list=nb.cluster.platform"
	use apisupport && clusters="${clusters},nb.cluster.apisupport"
	use harness && clusters="${clusters},nb.cluster.harness"
	use ide && clusters="${clusters},nb.cluster.ide"
	use j2ee && clusters="${clusters},nb.cluster.j2ee"
	use java && clusters="${clusters},nb.cluster.java"
	use mobility && clusters="${clusters},nb.cluster.mobility"
	use nb && clusters="${clusters},nb.cluster.nb"
	use profiler && clusters="${clusters},nb.cluster.profiler"
	use ruby && clusters="${clusters},nb.cluster.ruby"
	use soa && clusters="${clusters},nb.cluster.soa"
	use testtools && clusters="${clusters},nb.cluster.testtools"
	use uml && clusters="${clusters},nb.cluster.uml"
	use visualweb && clusters="${clusters},nb.cluster.visualweb"

	# Fails to compile
	java-pkg_filter-compiler ecj-3.1 ecj-3.2

	# First build Netbeans Platform (building using nb.cluster.platform doesn't work for unknown reason)
	ANT_TASKS="ant-nodeps"
	use testtools && ANT_TASKS="${ANT_TASKS} ant-trax"
	einfo "Compiling Netbeans Platform..."
	ANT_OPTS="-Xmx1g -Djava.awt.headless=true" eant ${antflags} \
		-f nbbuild/build.xml build-platform
	if ! use harness ; then
		rm -fr ${S}/nbbuild/netbeans/harness
		rm ${S}/nbbuild/netbeans/nb.cluster.harness.built
		sed -i -e "s%apisupport/harness.dir=.*{netbeans.dest.dir}/harness%%g" ${S}/nbbuild/netbeans/moduleCluster.properties
	fi

	# Build the rest of the clusters if any specified
	use ruby && addpredict /root/.jruby
	if use apisupport || use harness || use ide || use j2ee || use java || use mobility \
		|| use nb || use profiler || use ruby || use soa || use testtools || use uml \
		|| use visualweb ; then
		einfo "Compiling Netbeans IDE..."
		ANT_OPTS="-Xmx1g -Djava.awt.headless=true" eant ${antflags} ${clusters} -f nbbuild/build.xml build-nozip
	fi

	# Running build-javadoc from the same command line as build-nozip doesn't work
	# so we must run it separately
	use doc && ANT_OPTS="-Xmx1g" eant -f nbbuild/build.xml build-javadoc

	# Remove non-x86 Linux binaries
	find ${BUILDDESTINATION} -type f \
		-name "*.exe" -o \
		-name "*.cmd" -o \
		-name "*.bat" -o \
		-name "*.dll"	  \
		| xargs rm -f

	# Removing external stuff. They are api docs from external libs.
	rm -f ${BUILDDESTINATION}/ide${IDE_VERSION}/docs/*.zip

	# Remove zip files from generated javadocs.
	rm -f ${BUILDDESTINATION}/javadoc/*.zip

	# Use the system ant
	if use java ; then
		cd ${BUILDDESTINATION}/java1/ant || die "Cannot cd to ${BUILDDESTINATION}/ide${IDE_VERSION}/ant"
		rm -fr lib
		rm -fr bin
	fi

	# Set initial default jdk
	if [[ -e ${BUILDDESTINATION}/etc/netbeans.conf ]]; then
		echo "netbeans_jdkhome=\"\$(java-config -O)\"" >> ${BUILDDESTINATION}/etc/netbeans.conf
	fi

	# fix paths per bug# 163483
	if [[ -e ${BUILDDESTINATION}/bin/netbeans ]]; then
		sed -i -e 's:"$progdir"/../etc/:/etc/netbeans-6.0/:' ${BUILDDESTINATION}/bin/netbeans
		sed -i -e 's:"${userdir}"/etc/:/etc/netbeans-6.0/:' ${BUILDDESTINATION}/bin/netbeans
	fi
}

src_install() {
	insinto ${DESTINATION}

	einfo "Installing the program..."
	cd ${BUILDDESTINATION}
	doins -r *

	# Remove the build helper files
	rm -f ${D}/${DESTINATION}/nb.cluster.*
	rm -f ${D}/${DESTINATION}/*.built
	rm -f ${D}/${DESTINATION}/moduleCluster.properties
	rm -f ${D}/${DESTINATION}/module_tracking.xml
	rm -f ${D}/${DESTINATION}/build_info

	# Change location of etc files
	if [[ -e ${BUILDDESTINATION}/etc ]]; then
		insinto /etc/${PN}-${SLOT}
		doins ${BUILDDESTINATION}/etc/*
		rm -fr ${D}/${DESTINATION}/etc
		dosym /etc/${PN}-${SLOT} ${DESTINATION}/etc
	fi

	# Replace bundled jars with system jars
	symlink_extjars

	# Correct permissions on executables
	[[ -e ${D}/${DESTINATION}/bin/netbeans ]] && fperms 755 ${DESTINATION}/bin/netbeans
	fperms 775 ${DESTINATION}/platform${PLATFORM}/lib/nbexec
	use ruby && fperms 755 ${DESTINATION}/ruby1/jruby-0.9.9/bin/*

	# Link netbeans executable from bin
	if [[ -f ${D}/${DESTINATION}/bin/netbeans ]]; then
		dosym ${DESTINATION}/bin/netbeans /usr/bin/${PN}-${SLOT}
	else
		dosym ${DESTINATION}/platform7/lib/nbexec /usr/bin/${PN}-${SLOT}
	fi

	# Ant installation
	if use java ; then
		local ANTDIR="${DESTINATION}/java1/ant"
		dosym /usr/share/ant/lib ${ANTDIR}/lib
		dosym /usr/share/ant-core/bin ${ANTDIR}/bin
	fi

	# Documentation
	einfo "Installing Documentation..."

	cd ${D}/${DESTINATION}
	dohtml CREDITS.html README.html netbeans.css
	rm -f build_info CREDITS.html README.html netbeans.css

	use doc && java-pkg_dojavadoc ${S}/nbbuild/build/javadoc

	# Icons and shortcuts
	if use nb ; then
		einfo "Installing icon..."
		dodir /usr/share/icons/hicolor/32x32/apps
		dosym ${DESTINATION}/nb6.0/netbeans.png /usr/share/icons/hicolor/32x32/apps/netbeans-${SLOT}.png

	fi

	make_desktop_entry netbeans-${SLOT} "Netbeans ${SLOT}" netbeans-${SLOT}.png Development
}

pkg_postrm() {
	if ! test -e /usr/bin/netbeans-${SLOT}; then
		elog "Because of the way Portage works at the moment"
		elog "symlinks to the system jars are left to:"
		elog "${DESTINATION}"
		elog "If you are uninstalling Netbeans you can safely"
		elog "remove everything in this directory"
	fi
}

# Supporting functions for this ebuild

place_unpack_symlinks() {
	einfo "Symlinking jars for apisupport"
	cd ${S}/apisupport/external
	#java-pkg_jar-from --build-only jdom-1.0
	java-pkg_jar-from javahelp jhall.jar jsearch-2.0_04.jar
	#java-pkg_jar-from --build-only rome rome.jar rome-fetcher-0.6.jar
	#java-pkg_jar-from --build-only rome rome.jar rome-0.6.jar

	einfo "Symlinking jars for core"
	cd ${S}/core/external
	java-pkg_jar-from --build-only javahelp jh.jar jh-2.0_04.jar

	#if use httpserver ; then
	#	einfo "Symlinking jars for httpserver"
	#	cd ${S}/httpserver/external
	#	java-pkg_jar-from servletapi-2.2 servlet.jar servlet-2.2.jar
	#fi

	#if use j2ee ; then
	#	einfo "Symlinking jars for j2ee"
	#	cd ${S}/j2ee/external
	#	java-pkg_jar-from --build-only glassfish-persistence
	#fi

	#if use j2eeserver ; then
	#	einfo "Symlinking jars for j2eeserver"
	#	cd ${S}/j2eeserver/external
	#	java-pkg_jar-from sun-j2ee-deployment-bin-1.1 sun-j2ee-deployment-bin.jar jsr88javax.jar
	#fi

	#if use junit ; then
	#	einfo "Symlinking jars for junit"
	#	cd ${S}/junit/external
	#	java-pkg_jar-from junit junit.jar junit-3.8.2.jar
	#	java-pkg_jar-from junit-4 junit.jar junit-4.1.jar
	#fi

	#if use lexer ; then
	#	einfo "Symlinking jars for lexer"
	#	cd ${S}/lexer/external
	#	java-pkg_jar-from antlr antlr.jar antlr-2.7.1.jar
	#fi

	einfo "Symlinking jars for libs"
	cd ${S}/libs/external
	#java-pkg_jar-from --build-only commons-lang-2.1 commons-lang.jar commons-lang-2.1.jar
	#java-pkg_jar-from commons-logging commons-logging-api.jar commons-logging-api-1.1.jar
	#java-pkg_jar-from commons-logging commons-logging.jar commons-logging-1.0.4.jar
	#java-pkg_jar-from --build-only ical4j
	#java-pkg_jar-from --build-only jcalendar-1.2 jcalendar.jar jcalendar-1.3.2.jar
	#java-pkg_jar-from jsch jsch.jar jsch-0.1.24.jar
	#jar223-api.jar
	#java-pkg_jar-from --build-only pmd pmd.jar pmd-1.3.jar
	java-pkg_jar-from --build-only swing-layout-1 swing-layout.jar swing-layout-1.0.2.jar
	#java-pkg_jar-from --build-only xml-xmlbeans-1 xbean.jar xbean-1.0.4.jar
	#java-pkg_jar-from --build-only xerces-2 xercesImpl.jar xerces-2.8.0.jar

	#if use mobility ; then
	#	einfo "Symlinking jars for mobility"
	#	cd ${S}/mobility/deployment/ftpscp/external
	#	java-pkg_jar-from commons-net commons-net.jar commons-net-1.4.1.jar
	#	java-pkg_jar-from jakarta-oro-2.0 jakarta-oro.jar jakarta-oro-2.0.8.jar

	#	cd ${S}/mobility/deployment/webdav/external
	#	java-pkg_jar-from commons-httpclient
	#	java-pkg_jar-from commons-logging commons-logging.jar
	#	java-pkg_jar-from --build-only jdom-1.0

	#	cd ${S}/mobility/proguard/external
	#	java-pkg_jar-from proguard proguard.jar proguard3.5.jar
	#fi

	#if use serverplugins ; then
	#	einfo "Symlinking jars for serverplugins"
	#	cd ${S}/serverplugins/external
	#	java-pkg_jar-from --build-only sun-jmx jmxri.jar jmxremote.jar
	#fi

	#if use subversion ; then
	#	einfo "Symlinking jars for subversion"
	#	cd ${S}/subversion/external
	#fi

	#if use tasklist ; then
	#	einfo "Symlinking jars for tasklist"
	#	cd ${S}/tasklist/external
	#	java-pkg_jar-from antlr antlr.jar
	#	java-pkg_jar-from commons-beanutils-1.7 commons-beanutils-core.jar
	#	java-pkg_jar-from --build-only commons-cli-1
	#	java-pkg_jar-from commons-collections commons-collections.jar
	#	java-pkg_jar-from --build-only checkstyle
	#	java-pkg_jar-from --build-only ical4j
	#	java-pkg_jar-from --build-only jcalendar-1.2 jcalendar.jar jcalendar-1.3.0.jar
	#	java-pkg_jar-from --build-only jtidy Tidy.jar Tidy-r7.jar
	#fi

	#if use visualweb ; then
	#	einfo "Symlinking jars for visualweb"
	#	cd ${S}/visualweb/ravehelp/external
	#	java-pkg_jar-from javahelp jhall.jar jhall-2.0_02.jar

	#	cd ${S}/visualweb/ravelibs/commons-beanutils/release/modules/ext
	#	java-pkg_jar-from commons-beanutils-1.7 commons-beanutils.jar

	#	cd ${S}/visualweb/ravelibs/commons-collections/release/modules/ext
	#	java-pkg_jar-from commons-collections

	#	cd ${S}/visualweb/ravelibs/commons-digester/release/modules/ext
	#	java-pkg_jar-from commons-digester

	#	cd ${S}/visualweb/ravelibs/commons-fileupload/release/modules/ext
	#	java-pkg_jar-from commons-fileupload

	#	cd ${S}/visualweb/ravelibs/commons-logging/release/modules/ext
	#	java-pkg_jar-from commons-logging commons-logging.jar
	#fi

	#if use web ; then
	#	einfo "Symlinking jars for web"
	#	cd ${S}/web/external
	#	java-pkg_jar-from --build-only commons-el
	#	java-pkg_jar-from jakarta-jstl jstl.jar jstl-1.1.2.jar
	#	java-pkg_jar-from --build-only servletapi-2.3 servlet.jar servlet-2.3.jar
	#	java-pkg_jar-from jakarta-jstl standard.jar standard-1.1.2.jar
	#fi

	#if use xml ; then
	#	einfo "Symlinking jars for xml"
	#	cd ${S}/xml/external
		#java-pkg_jar-from flute
		#java-pkg_jar-from --build-only commons-jxpath commons-jxpath.jar jxpath1.1.jar
		#java-pkg_jar-from --build-only prefuse-2006 prefuse.jar prefuse.jar
		#java-pkg_jar-from sac
	#fi
}

symlink_extjars() {
	local targetdir=""

	#einfo "Symlinking enterprise jars"

	#cd ${1}/enterprise${ENTERPRISE}/modules/ext
	#java-pkg_jar-from sun-j2ee-deployment-bin-1.1 sun-j2ee-deployment-bin.jar jsr88javax.jar
	#java-pkg_jar-from jakarta-jstl jstl.jar
	#java-pkg_jar-from jakarta-jstl standard.jar

	#cd ${1}/enterprise${ENTERPRISE}/modules/ext/blueprints
	#java-pkg_jar-from commons-fileupload commons-fileupload.jar commons-fileupload-1.1.1.jar
	#java-pkg_jar-from commons-io-1 commons-io.jar commons-io-1.2.jar
	#java-pkg_jar-from commons-logging commons-logging.jar commons-logging-1.1.jar

	#cd ${1}/enterprise${ENTERPRISE}/modules/ext/jsf
	#java-pkg_jar-from commons-beanutils-1.7 commons-beanutils.jar
	#java-pkg_jar-from commons-collections commons-collections.jar
	#java-pkg_jar-from commons-digester commons-digester.jar
	#java-pkg_jar-from commons-logging commons-logging.jar

	#cd ${1}/enterprise${ENTERPRISE}/modules/ext/struts
	#java-pkg_jar-from antlr antlr.jar
	#java-pkg_jar-from commons-beanutils-1.7 commons-beanutils.jar
	#java-pkg_jar-from commons-digester commons-digester.jar
	#java-pkg_jar-from commons-fileupload commons-fileupload.jar
	#java-pkg_jar-from commons-logging commons-logging.jar
	#java-pkg_jar-from commons-validator commons-validator.jar
	#java-pkg_jar-from jakarta-oro-2.0 jakarta-oro.jar
	#java-pkg_jar-from struts-1.2 struts.jar


	if use harness ; then
		einfo "Symlinking harness jars"
		targetdir="harness"
		dosymjar ${targetdir} javahelp jhall.jar jsearch-2.0_04.jar
	fi


	#einfo "Symlinking ide jars"

	#cd ${1}/ide${IDE_VERSION}/modules/ext
	#java-pkg_jar-from commons-logging commons-logging.jar commons-logging-1.0.4.jar
	#java-pkg_jar-from flute
	#java-pkg_jar-from jsch jsch.jar jsch-0.1.24.jar
	#java-pkg_jar-from junit junit.jar junit-3.8.2.jar
	#java-pkg_jar-from sac
	#java-pkg_jar-from servletapi-2.2 servlet.jar servlet-2.2.jar
	#java-pkg_jar-from xerces-2 xercesImpl.jar xerces-2.8.0.jar

	#cd ${1}/ide${IDE_VERSION}/modules/ext/jaxrpc16
	#java-pkg_jar-from sun-jaf
	#java-pkg_jar-from fastinfoset fastinfoset.jar FastInfoset.jar
	#java-pkg_jar-from jaxp
	#java-pkg_jar-from jsr101
	#java-pkg_jar-from jax-rpc jaxrpc-impl.jar
	#java-pkg_jar-from jax-rpc jaxrpc-spi.jar
	#java-pkg_jar-from jsr173 jsr173.jar jsr173_api.jar
	#java-pkg_jar-from sun-javamail
	#java-pkg_jar-from relaxng-datatype
	#java-pkg_jar-from jsr67 jsr67.jar saaj-api.jar
	#java-pkg_jar-from saaj saaj.jar saaj-impl.jar
	#java-pkg_jar-from xsdlib

	#cd ${1}/ide${IDE_VERSION}/modules/ext/jaxws21
	#java-pkg_jar-from sun-jaf
	#java-pkg_jar-from fastinfoset fastinfoset.jar FastInfoset.jar
	#java-pkg_jar-from jaxb-2 jaxb-impl.jar
	#java-pkg_jar-from jaxb-tools-2 jaxb-tools.jar jaxb-xjc.jar
	#java-pkg_jar-from jax-ws-2 jax-ws.jar jaxws-rt.jar
	#java-pkg_jar-from jax-ws-2 jax-ws.jar jaxws-tools.jar
	#java-pkg_jar-from jsr173 jsr173.jar jsr173_api.jar
	#java-pkg_jar-from jsr250
	#java-pkg_jar-from saaj saaj.jar saaj-impl.jar
	#java-pkg_jar-from sjsxp

	#cd ${1}/ide${IDE_VERSION}/modules/ext/jaxws21/api
	#java-pkg_jar-from jaxb-2 jaxb-api.jar
	#java-pkg_jar-from jax-ws-api-2 jax-ws-api.jar jaxws-api.jar
	#java-pkg_jar-from jsr181 jsr181.jar jsr181-api.jar
	#java-pkg_jar-from jsr67 jsr67.jar saaj-api.jar


	einfo "Symlinking platform jars"

	targetdir="platform${PLATFORM}/modules/ext"
	dosymjar ${targetdir} javahelp jh.jar jh-2.0_04.jar
	dosymjar ${targetdir} swing-layout-1 swing-layout.jar swing-layout-1.0.2.jar

	#if use mobility ; then
	#	einfo "Symlinking mobility jars"

	#	cd ${1}/extra/external
	#	java-pkg_jar-from commons-httpclient
	#	java-pkg_jar-from commons-logging commons-logging.jar
	#	java-pkg_jar-from jdom-1.0

	#	cd ${1}/extra/external/proguard
	#	java-pkg_jar-from proguard proguard.jar proguard3.5.jar

	#	cd ${1}/extra/modules/ext
	#	java-pkg_jar-from commons-net commons-net.jar commons-net-1.4.1.jar
	#	java-pkg_jar-from jakarta-oro-2.0 jakarta-oro.jar jakarta-oro-2.0.8.jar
	#fi
}

dosymjar() {
	local target_file=""
	if [ -z "${4}" ]; then
		target_file="${3}"
	else
		target_file="${4}"
	fi
	local target="${DESTINATION}/${1}/${target_file}"
	[ ! -e "${D}/${target}" ] && die "Target jar does not exist so will not create link: ${D}/${target}"
	dosym /usr/share/${2}/lib/${3} ${target}
}

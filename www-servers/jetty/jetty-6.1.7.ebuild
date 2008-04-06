# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $ 

## TODO :
# 2) More testing/QA (Especially the WADI clustering bits)
# 3) Package JSP related things
# 4) In the original binary there's a million property files that should maybe
# be included?
# 5) Decide if the following included jars should be packaged even if they are
# not from source
# /opt/jetty-orig/contrib/eclipse-generic-wst-plugin/site/features/org.mortbay.jetty.serveradaptor_1.0.0.jar
# /opt/jetty-orig/contrib/eclipse-generic-wst-plugin/site/plugins/org.mortbay.jetty.serveradaptor_1.0.0.jar
# 6) Should I package the win32 stuff ;) *cough*
# 7) Should I package these?
#	contrib/jetty-ant/target/jetty-ant-6.1.7.jar
#	modules/maven-plugin/target/maven-jetty-plugin-6.1.7.jar
#	modules/jspc-maven-plugin/target/maven-jetty-jspc-plugin-6.1.7.jar
#	modules/jsp-api-2.0/target/jsp-api-2.0-6.1.7.jar
#	examples/tests/target/extratests-6.1.7.jar
#	examples/embedded/target/jetty-embedded-6.1.7.jar
# 8) jetty-spring which depends on spring 1.x ends up being a looong chain of dependancies
# 9) Package the docs / source
# 10) j2se6 stuff?
# 11) Terracotta?
# 12) Suggestions or what else am I missing that people need?


#JAVA_PKG_IUSE="doc source"
JAVA_MAVEN_BUILD_SYSTEM="eant"
EAPI=1

inherit eutils java-pkg-2 java-maven-2 
#java-ant-2

DESCRIPTION="A Lightweight Servlet Engine"
SRC_URI="http://ftp.mortbay.org/pub/jetty-${PV}/jetty-${PV}-src.zip"
HOMEPAGE="http://www.mortbay.org/"
KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="Apache-1.1"
SLOT="0"
IUSE="wadi demo"

COMMON_DEP=""

RDEPEND=">=virtual/jre-1.4
	wadi? ( dev-java/wadi )
    ${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4 
    app-arch/unzip
    ${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}/build-jetty-${PV}.patch
}


EANT_GENTOO_CLASSPATH=""
EANT_BUILD_TARGET="clean compile package"

src_compile() {
	eant package
}

pkg_preinst() {
	enewgroup jetty
	enewuser jetty -1 /bin/bash /opt/jetty jetty
	chown -R jetty:jetty ${D}
}

src_install() {
	JETTY_HOME="/opt/jetty"

	INSTALLING="yes"
	diropts -m0750
	
	# Create directories
	dodir ${JETTY_HOME}
	dodir ${JETTY_HOME}/tmp
	dodir ${JETTY_HOME}/lib
	dodir ${JETTY_HOME}/lib/ext
	dodir ${JETTY_HOME}/lib/plus
	dodir ${JETTY_HOME}/lib/wadi
	dodir ${JETTY_HOME}/lib/xbean
	dodir ${JETTY_HOME}/lib/management
	dodir ${JETTY_HOME}/lib/cometd
	dodir ${JETTY_HOME}/lib/naming
	dodir ${JETTY_HOME}/lib/grizzly
	dodir ${JETTY_HOME}/lib/jsp-2.1

	keepdir ${JETTY_HOME}/tmp
	dodir /var/log/${PN}
	keepdir /var/log/${PN}
	dosym /var/log/${PN}/ ${JETTY_HOME}/logs

	java-pkg_jarinto "${JETTY_HOME}/"
	java-pkg_newjar "modules/start/target/start-${PV}.jar" start.jar

	java-pkg_jarinto "${JETTY_HOME}/lib/"
	java-pkg_dojar "modules/jetty/target/jetty-${PV}.jar"
	java-pkg_dojar "modules/util/target/jetty-util-${PV}.jar"
	java-pkg_dojar "modules/servlet-api-2.5/target/servlet-api-2.5-6.1.7.jar"
	java-pkg_dojar "modules/annotations/target/jetty-annotations-${PV}.jar"

	java-pkg_jarinto "${JETTY_HOME}/lib/ext/"
	java-pkg_dojar "extras/client/target/jetty-client-${PV}.jar"
	java-pkg_dojar "extras/ajp/target/jetty-ajp-${PV}.jar"
	java-pkg_dojar "modules/html/target/jetty-html-${PV}.jar"
	java-pkg_dojar "extras/sslengine/target/jetty-sslengine-${PV}.jar"
	java-pkg_dojar "extras/threadpool/target/jetty-java5-threadpool-${PV}.jar"
	java-pkg_dojar "extras/servlet-tester/target/jetty-servlet-tester-${PV}.jar"

	java-pkg_jarinto "${JETTY_HOME}/lib/plus/"
	java-pkg_dojar "modules/plus/target/jetty-plus-${PV}.jar"

	java-pkg_jarinto "${JETTY_HOME}/lib/xbean/"
	java-pkg_dojar "extras/xbean/target/jetty-xbean-${PV}.jar"

	java-pkg_jarinto "${JETTY_HOME}/lib/management/"
	java-pkg_dojar "modules/management/target/jetty-management-${PV}.jar"

	java-pkg_jarinto "${JETTY_HOME}/lib/cometd/"
	# Probably not needed, but being built
	java-pkg_dojar "contrib/cometd/api/target/cometd-api-0.9.20071211.jar"

	# Appears to be for a demo.. maybe in the future..
	#java-pkg_dojar "contrib/cometd/demo/target/cometd-demo-${PV}/WEB-INF/lib/cometd-bayeux-${PV}.jar"
	java-pkg_dojar "contrib/cometd/bayeux/target/cometd-bayeux-${PV}.jar"
	java-pkg_dojar "contrib/cometd/client/target/bayeux-client-${PV}.jar"

	java-pkg_jarinto "${JETTY_HOME}/lib/naming/"
	java-pkg_dojar "modules/naming/target/jetty-naming-${PV}.jar"

	java-pkg_jarinto "${JETTY_HOME}/lib/grizzly/"
	java-pkg_dojar "contrib/grizzly/target/jetty-grizzly-${PV}.jar"

	java-pkg_jarinto "${JETTY_HOME}/lib/jsp-2.1/"
	java-pkg_newjar "modules/jsp-2.1/target/jsp-2.1-${PV}.jar" jsp-2.1.jar
	java-pkg_newjar "modules/jsp-api-2.1/target/jsp-api-2.1-${PV}.jar" jsp-api-2.1.jar

	if use wadi; then
		java-pkg_jarinto "${JETTY_HOME}/lib/wadi/"
		java-pkg_dojar "contrib/wadi/target/jetty-wadi-session-manager-${PV}.jar"
	fi

	# Needed or jetty won't start
	dodir ${JETTY_HOME}/webapps
	keepdir ${JETTY_HOME}/webapps

	if use demo; then
		cp -rf examples/test-webapp/src/main/webapp/ ${D}/${JETTY_HOME}/webapps/test
		dodir ${JETTY_HOME}/webapps/test/WEB-INF
		cp -rf examples/test-webapp/target/classes	${D}/${JETTY_HOME}/webapps/test/WEB-INF/

		cp -rf examples/test-jaas-webapp/src/main/webapp/ ${D}/${JETTY_HOME}/webapps/test-jaas

		# Missing some jars and won't deploy
		# cp contrib/cometd/demo/target/cometd-demo-${PV}.war	${D}/${JETTY_HOME}/webapps/cometd.war
	fi

	#use doc && java-pkg_dojavadoc "${WORKDIR}/gentoo_javadoc"
	#use source && java-pkg_dosrc src/main/java/*

	# Some directories that are also in the binary jetty
	dodir ${JETTY_HOME}/bin
	dodir ${JETTY_HOME}/contexts
	dodir ${JETTY_HOME}/contrib
	dodir ${JETTY_HOME}/examples
	dodir ${JETTY_HOME}/extras
	dodir ${JETTY_HOME}/javadoc
	dodir ${JETTY_HOME}/modules
	dodir ${JETTY_HOME}/patches
	dodir ${JETTY_HOME}/project-website
	dodir ${JETTY_HOME}/resources
	
	# Necessary Jetty configs
	dodir /etc/jetty
	dosym /etc/jetty/ ${JETTY_HOME}/etc
	insinto /etc/jetty/
	doins etc/jetty-grizzly.xml
	doins etc/jetty-ajp.xml
	doins etc/jetty-setuid.xml
	doins etc/jetty-bio.xml
	doins etc/jetty-plus.xml
	doins etc/jetty-sslengine.xml
	doins etc/jetty.xml
	doins etc/webdefault.xml
	doins etc/jetty-jmx.xml
	doins etc/jetty-jaas.xml
	doins etc/jetty-ssl.xml
	doins etc/jetty-logging.xml

	# Necessary property files
	doins etc/login.properties
	doins etc/jdbcRealm.properties
	doins etc/realm.properties

	# INIT SCRIPTS AND ENV
	newinitd ${FILESDIR}/${PV}/jetty.init jetty
	insinto ${JETTY_HOME}/bin
	doins bin/jetty.sh
	

	doenvd ${FILESDIR}/${PV}/21jetty

	insinto /etc/
	insopts -m0644
	doins ${FILESDIR}/${PV}/jetty.conf

	doconfd ${FILESDIR}/${PV}/jetty

	dodoc *.TXT
	dohtml *.html

	chmod u+x ${S}/bin/jetty.sh

}

pkg_postinst() {
	einfo
	einfo " NOTICE!"
	einfo " User and group 'jetty' have been added."
	einfo
	elog " FILE LOCATIONS:"
	elog " 1.  Jetty home directory: ${JETTY_HOME}"
	elog "     Contains application data, configuration files."
	elog " 2.  Runtime settings: /etc/conf.d/jetty"
	elog "     Contains CLASSPATH,JAVA_HOME,JAVA_OPTIONS,JETTY_PORT"
	elog "              JETTY_USER,JETTY_CONF setting"
	elog " 3.  You can configure your 'webapp'-lications in /etc/jetty.conf"
	elog "     (the default configured webapps are the JETTY's demo/admin)"
	elog " 4.  For more information about JETTY refer to jetty.mortbay.org"
	elog " 5.  Logs are located at:"
	elog "                              /var/log/jetty/"
	elog
	elog " STARTING AND STOPPING JETTY:"
	elog "   /etc/init.d/jetty start"
	elog "   /etc/init.d/jetty stop"
	elog "   /etc/init.d/jetty restart"
	elog
	elog
	elog " NETWORK CONFIGURATION:"
	elog " By default, Jetty runs on port 8080.  You can change this"
	elog " value by setting JETTY_PORT in /etc/conf.d/jetty ."
	elog
	elog " To test Jetty while it's running, point your web browser to:"
	elog " http://localhost:8080/"
	elog
	elog " BUGS:"
	elog " Please file any bugs at http://bugs.gentoo.org/ or else it"
	elog " may not get seen. Thank you!"
	elog
}

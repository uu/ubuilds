# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-logging/commons-logging-1.1-r2.ebuild,v 1.9 2007/04/07 04:28:54 wltjr Exp $

JAVA_PKG_IUSE="doc source test"
#WANT_ANT_TASKS="castor-1.0,sablecc"
#WANT_ANT_TASKS="sablecc-anttask"


inherit java-pkg-2 java-ant-2

DESCRIPTION="Enterprise grade network management platform"

MY_PV="${PV%.*}-${PV##*.}"
MY_P="${PN}-source-${MY_PV}"

SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
HOMEPAGE="http://www.opennms.org/"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"

SLOT="0"

COMMON_DEPEND="=dev-java/avalon-framework-4.2*
		=dev-java/avalon-logkit-1.2*
		=dev-java/batik-1.6*
		>=dev-java/bsf-2.3
		dev-java/bsh
		dev-java/c3p0
		=dev-java/castor-1.1*
		dev-java/commons-jxpath
		dev-java/fop
		dev-java/java-getopt
		=dev-java/jakarta-regexp-1.3*
		=dev-java/jakarta-oro-2.0*
		dev-java/jcifs
		dev-java/jdbc-postgresql
		dev-java/jrobin
		dev-java/jta
		dev-java/log4j
		=dev-java/mx4j-core-3.0*
		=dev-java/mx4j-tools-3.0*
		dev-java/sablecc
		dev-java/sablecc-anttask
		=dev-java/smack-2.2*
		dev-java/sun-jaf
		dev-java/sun-javamail
		dev-java/sun-jimi
		=dev-java/tomcat-servlet-api-6.0*
		dev-java/xalan
		>=dev-java/xerces-2
		dev-java/xml-commons
		dev-java/xmlrpc
		dev-db/hsqldb"
RDEPEND="=virtual/jre-1.5.0
	${COMMON_DEPEND}"
DEPEND="=virtual/jdk-1.5.0
	test? ( dev-java/junit )
	${COMMON_DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}/source/"

src_unpack() {
	unpack ${A}
	cd "${S}"

	einfo "Removing bundled classes and jars"
	find "${S}" '(' -name '*.class' -o -name '*.jar' ')' -print -delete

#	cd "${S}/servlet/lib/build/"
#	java-pkg_jar-from tomcat-servlet-api-2.5 servlet-api.jar servlet-api-2.5.jar

}

# Missing
# catalina.jar jdhcp.jar jmta.jar jradius-client.jar ldap.jar mailapi.jar
# pylib152e.jar w3c.jar 

EANT_ANT_TASKS="sablecc-anttask"
#EANT_ANT_TASKS="castor-1.0 sablecc-anttask"
EANT_BUILD_TARGET="dist"
EANT_DOC_TARGET="docs"
EANT_GENTOO_CLASSPATH="sun-jaf,avalon-framework-4.2,batik-1.6,bsf-2.3,bsh,c3p0,castor-1.0, \
	commons-jxpath,fop,java-getopt-1,hsqldb,sun-javamail,jakarta-regexp-1.3, \
	jcifs-1.1,sun-jimi,jrobin,jta,log4j,avalon-logkit-1.2, \
	mx4j-core-3.0,mx4j-tools-3.0,jakarta-oro-2.0, \
	jdbc-postgresql,sablecc,tomcat-servlet-api-2.5,smack-2.2,xalan, \
	xerces-2,xml-commons,xmlrpc"

src_test() {
	java-pkg_jar-from --into lib/build junit

	cd "${S}"
	ANT_TASKS="" eant test
}

src_install() {

	die "Not implemented yet :)"
#	java-pkg_newjar build/dist/${P}.jar ${PN}.jar
#	java-pkg_newjar servlet/build/dist/${PN}-servlet-${PV}.jar ${PN}-servlet.jar
#	java-pkg_newjar spring/build/dist/${PN}-spring-${PV}.jar ${PN}-spring.jar
#	java-pkg_newjar struts2/build/dist/${PN}-struts2-plugin-${PV}.jar ${PN}-struts2-plugin.jar

	use doc && java-pkg_dojavadoc javadoc/
	use source && java-pkg_dosrc src/com
}

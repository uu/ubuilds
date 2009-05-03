# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A Java implementation of the OPeNDAP Data Access Protocol."
HOMEPAGE="http://www.openldap.org/"

#this needs to be updated.  that zip is generated on each hit.  Bad Joo Joo.
SRC_URI="http://scm.opendap.org:8090/trac/changeset/20853/tags/Java-OPeNDAP/0.0.10?old_path=%2F&format=zip
-> ${P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

COMMON_DEP="dev-java/commons-codec:0
	dev-java/commons-httpclient:3
	dev-java/commons-logging:0
	dev-java/java-getopt:1
	dev-java/gnu-regexp:1
	dev-java/jdom:1.0
	dev-java/xerces:2
	dev-java/xml-commons:0"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	java-virtuals/servlet-api:2.4
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}/tags/Java-OPeNDAP/${PV}"

#Haven't done the tests
RESTRICT="test"

java_prepare() {
	java-pkg_jar-from --into lib commons-codec commons-codec.jar \
		commons-codec-1.3.jar
	java-pkg_jar-from --into lib commons-httpclient-3 commons-httpclient.jar \
		commons-httpclient-3.0.1.jar
	java-pkg_jar-from --into lib commons-logging commons-logging.jar \
		commons-logging-1.1.jar
	java-pkg_jar-from --into lib java-getopt-1 gnu.getopt.jar \
		java-getopt-1.0.6.jar
	java-pkg_jar-from --into lib gnu-regexp-1 gnu-regexp.jar \
		java-regexp-1.1.4.jar
	java-pkg_jar-from --into lib jdom-1.0 jdom.jar \
		jdom-1.0.jar

	rm -v lib/junit*.jar
	#TODO sljr

	java-pkg_jar-from --build-only --into lib servlet-api-2.4 servlet-api.jar \
		tomcat-5.5.20_servlet-api.jar
	java-pkg_jar-from --into lib xerces-2 xercesImpl.jar xercesImpl-2.9.0.jar
	java-pkg_jar-from --into lib  xml-commons xml-apis.jar xml-apis-2.9.0.jar
}

EANT_BUILD_TARGET="opendap-lib"
EANT_DOC_TARGET="doc"

#TODO war

src_install() {
	java-pkg_newjar "build/lib/${PN}-Not.A.Release.jar"
	use doc && java-pkg_dojavadoc build/doc/javadoc
	dohtml -r build/doc/*.html images
	use source && java-pkg_dosrc src

	java-pkg_dolauncher geturl --main opendap.util.geturl.Geturl
}


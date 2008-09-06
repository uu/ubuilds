# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-junit"

inherit java-pkg-2 java-ant-2

MY_P="${PN}-$(replace_version_separator '_' '-')"

DESCRIPTION="A collection of tools for parsing XML."
HOMEPAGE="http://e-xml.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""


RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
		test? ( dev-java/junit:0 java-virtuals/servlet-api:2.2 )"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -Rf build lib/*.jar
}

EANT_BUILD_TARGET="dist-jar"
EANT_JAVADOC_TARGET="javadoc"

src_test() {
	java-pkg_jar-from --build-only --into lib junit
	java-pkg_jar-from --build-only --into lib servlet-api-2.2
	eant test
}

src_install() {
	java-pkg_newjar build/xmlrpc.classes.jar
	use doc && java-pkg_dojavadoc build/javadoc
	find src -name 'CVS' | xargs rm -R
	use source && java-pkg_dosrc src
}


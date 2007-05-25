# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jdom/jdom-1.0_beta9-r2.ebuild,v 1.5 2007/01/05 23:31:51 caster Exp $

JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-ant-2

IUSE=""

MY_PN="jdom"
MY_PV="b9"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Java API to manipulate XML data"
SRC_URI="http://www.jdom.org/dist/source/${MY_P}.tar.gz"
HOMEPAGE="http://www.jdom.org"
LICENSE="JDOM"
SLOT="${PV}"
KEYWORDS="~amd64"

RDEPEND=">=virtual/jre-1.4
		dev-java/saxpath
		dev-java/xalan
		>=dev-java/xerces-2.7"
DEPEND=">=virtual/jdk-1.4
		dev-java/ant-core
		${RDEPEND}"

PDEPEND="~dev-java/jdom-jaxen-${PV}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd ${S}
	rm -f build/*.jar lib/*.jar
	rm src/java/org/jdom/xpath/JaxenXPath.java || die "Unable to remove class"

	cd ${S}/lib
	java-pkg_jar-from saxpath
	java-pkg_jar-from xerces-2
}

EANT_BUILD_TARGET="package"
EANT_DOC_TARGET=""
# to prevent a newer jdom from going into cp
ANT_TASKS="none"

src_compile() {

	eant package || die "compile problem"

}

src_install() {
	java-pkg_dojar build/*.jar

	dodoc CHANGES.txt COMMITTERS.txt README.txt TODO.txt
	use doc && java-pkg_dohtml -r build/apidocs/*
	use source && java-pkg_dosrc src/java/*
}

pkg_postinst() {
		elog ""
		elog "If you want jaxen support for jdom then"
		elog "please emerge =dev-java/jdom-jaxen-${PV}."
		elog ""
}

# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

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

src_install() {
	java-pkg_dojar build/*.jar

	java-pkg_register-dependency "jdom-jaxen-1.0_beta9"

	dodoc CHANGES.txt COMMITTERS.txt README.txt TODO.txt
	use doc && java-pkg_dohtml -r build/apidocs/*
	use source && java-pkg_dosrc src/java/*
}

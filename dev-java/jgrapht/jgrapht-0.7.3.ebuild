# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JGraphT is a free Java graph library that provides mathematical
graph-theory objects and algorithms."
HOMEPAGE="http://jgrapht.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

COMMON_DEP="dev-java/jgraph
			dev-java/touchgraph-graphlayout"

RDEPEND=">=virtual/jre-1.5
		${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
		test? ( dev-java/junit:0
			dev-java/xmlunit:1 )
		${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd "${S}/lib"

	rm -fv *.jar ../*.jar
	java-pkg_jarfrom jgraph
	java-pkg_jarfrom touchgraph-graphlayout TGGraphLayout.jar
}

src_install() {
	java-pkg_newjar *.jar
	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src
}

src_test() {
	java-pkg_jarfrom --into lib junit
	java-pkg_jarfrom --into lib xmlunit-1 xmlunit.jar xmlunit1.0.jar
	ANT_TASKS="ant-junit" eant test
}

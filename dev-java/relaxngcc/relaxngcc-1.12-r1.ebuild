# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_DATE="20031218"

DESCRIPTION="RELAX NG Compiler Compiler"
HOMEPAGE="http://relaxngcc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-${MY_DATE}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=virtual/jre-1.4
	dev-java/relaxng-datatype
	dev-java/msv
	dev-java/ant-core
	dev-java/xsdlib"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}"

S="${WORKDIR}/${PN}-${MY_DATE}"

src_unpack() {

	unpack ${A} || die
	cd "${S}" || die
	mv relaxngcc.jar relaxngcc.orig.jar || die

	mkdir lib || die
	cd lib || die
	java-pkg_jarfrom relaxng-datatype
	java-pkg_jarfrom msv
	java-pkg_jarfrom xsdlib
	java-pkg_jarfrom ant-core
	cd "${S}" || die

	cp "${FILESDIR}/build.xml-1.12-r1" build.xml || die "cp failed"
	rm -rf "src/relaxngcc/maven"
	java-pkg_filter-compiler jikes
}

EANT_DOC_TARGET=""

src_install() {

	java-pkg_dojar relaxngcc.jar

	use source && java-pkg_dosrc src/*

	dodoc readme.txt || die
	use doc && dohtml -r doc/en/*

}

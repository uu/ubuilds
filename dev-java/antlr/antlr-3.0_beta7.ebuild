# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source test"
WANT_ANT_TASKS="ant-antlr ant-junit"
inherit eutils java-pkg-2 java-ant-2

MY_P=${P/_beta/b}
S=${WORKDIR}/${MY_P}
DESCRIPTION="A parser generator for C++, C#, Java, and Python"
HOMEPAGE="http://www.antlr.org/"
SRC_URI="http://www.antlr.org/download/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="3"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.5
	 dev-java/stringtemplate"

DEPEND="${RDEPEND}
	>=virtual/jdk-1.5
	test?
	(
		dev-java/junit
		=dev-java/antlr-2*
	)"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/buildfixes.patch
	cd lib
	rm *.jar
	java-pkg_jarfrom stringtemplate
	use test && java-pkg_jarfrom --build-only antlr,junit
	#antlr2 may need to be slotted
}

src_compile() {
	eant -Dantlr3.jar=antlr3.jar build
}

src_test() {
	ANT_TASKS="ant-antlr ant-junit" eant test
}

src_install() {
	java-pkg_dojar antlr3.jar
	use source && java-pkg_dosrc src/*
	dodoc README.txt || die
}

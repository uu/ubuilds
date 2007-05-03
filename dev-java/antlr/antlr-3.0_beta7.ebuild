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
KEYWORDS=""
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
	find -name "*.jar" | xargs rm -v
	java-ant_rewrite-classpath
	#antlr2 may need to be slotted
}

src_compile() {
	eant -Dantlr3.jar=antlr3.jar build -Dgentoo.classpath=$(java-pkg_getjars stringtemplate):$(java-pkg_getjars --build-only antlr,junit)
}

src_test() {
	ANT_TASKS="ant-antlr ant-junit" eant test -Dgentoo.classpath=$(java-pkg_getjars antlr,junit)
}

src_install() {
	java-pkg_dojar antlr3.jar
	use source && java-pkg_dosrc src/*
	dodoc README.txt || die
}

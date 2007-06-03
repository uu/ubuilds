# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source test"
WANT_ANT_TASKS="ant-antlr"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A parser generator for C++, C#, Java, and Python"
HOMEPAGE="http://www.antlr.org/"
SRC_URI="http://www.antlr.org/download/${P}.tar.gz"
LICENSE="BSD"
SLOT="3"
KEYWORDS=""
IUSE="test"
# operates in /tmp and some tests fail
RESTRICT="test"

CDEPEND="dev-java/stringtemplate
	 =dev-java/antlr-2*"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

DEPEND="${RDEPEND}
	>=virtual/jdk-1.5
	=dev-java/junit-3*
	test? (
		dev-java/ant-junit
		dev-java/ant-trax
	)
	${CDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# some available magic for bcel just for version string, nonsense
	java-ant_ignore-system-classes
	# no point in separate runtime.jar, which doesn't have own build.xml target
	# anyway, and bundled antlr-3.0.jar contains runtime classes too
	cp -R runtime/Java/src/org src || die
	# force regeneration of grammar to source with antlr-2
	find src -name '*.g' -exec touch '{}' ';' || die
	cd lib
	rm -v *.jar || die
	# testcases are always built but excluded in <jar>
	java-pkg_jar-from --build-only junit
	java-pkg_jar-from antlr,stringtemplate
}

src_compile() {
	eant -Dversion=${PV} -Djar.version=3 build
}

src_test() {
	ANT_TASKS="ant-antlr ant-junit ant-trax" eant -Djava.io.tmpdir="${T}" test
}

src_install() {
	java-pkg_dojar lib/antlr3.jar
	java-pkg_dolauncher antlr3 --main org.antlr.Tool

	dodoc README.txt || die
	use source && java-pkg_dosrc src/org
}

# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source test"
WANT_ANT_TASKS="ant-antlr ant-junit"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A parser generator for C++, C#, Java, and Python"
HOMEPAGE="http://www.antlr.org/"
SRC_URI="http://www.antlr.org/download/${P}.tar.gz"
LICENSE="BSD"
SLOT="3"
KEYWORDS="~amd64 ~x86"
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
	#epatch ${FILESDIR}/buildfixes.patch
	sed -i -e 's:depends=\"compile\":depends=\"compile,templates\":g' build.xml
	#find -name "*.jar" | xargs rm -v
	cd lib
	#need to keep one of antlr/anlt-runtime to break self dependency
	rm antlr-2*.jar antlr-runtime-3*.jar stringtemplate-3*.jar
	java-pkg_jar-from --build-only antlr,junit
	java-pkg_jar-from stringtemplate
	#java-ant_rewrite-classpath
	#antlr2 may need to be slotted
}

src_compile() {
	find . -name '*.class' -print > classes.list
  	touch myManifest
  	jar cmf myManifest "${S}/lib/antlr3-runtime.jar" @classes.list
  	cd "${S}"
	#eant -Dantlr3.jar=antlr3.jar build -Dgentoo.classpath=$(java-pkg_getjars stringtemplate):$(java-pkg_getjars --build-only antlr,junit)
	eant -Dantlr3.jar=antlr3.jar build
}

src_test() {
	#ANT_TASKS="ant-antlr ant-junit" eant test -Dgentoo.classpath=$(java-pkg_getjars antlr,junit)
	ANT_TASKS="ant-antlr ant-junit" eant -Dtemp.dir=${T}/antlr3 test
}

src_install() {
	java-pkg_dojar antlr3.jar
	java-pkg_dojar lib/antlr3-runtime.jar
	#java-pkg_dojar lib/antlr3-tool.jar
	use source && java-pkg_dosrc src/*
	dodoc README.txt || die
}

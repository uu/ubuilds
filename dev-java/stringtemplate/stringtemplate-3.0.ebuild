# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A Java template engine"
HOMEPAGE="http://www.stringtemplate.org/"
SRC_URI="http://www.antlr.org/download/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="dev-java/antlr"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.4
	${COMMON_DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	find -name "*.jar" | xargs rm -v
	java-ant_rewrite-classpath
}

src_compile() {
	ANT_TASKS="ant-antlr" eant jar $(use_doc javadocs) -Dgentoo.classpath=$(java-pkg_getjars antlr)
}

src_install() {
	java-pkg_dojar build/stringtemplate.jar
	use doc && java-pkg_dojavadoc docs/api
	use source && java-pkg_dosrc src/*
	dodoc README.txt || die
}

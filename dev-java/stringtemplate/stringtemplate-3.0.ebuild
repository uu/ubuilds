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
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.4"

DEPEND="${RDEPEND}
	>=virtual/jdk-1.4"

EANT_BUILD_TARGET="jar"
EANT_DOC_TARGET="javadocs"

src_unpack() {
	unpack ${A}
	cd ${S}/lib
	rm *.jar
}

src_install() {
	java-pkg_dojar build/stringtemplate.jar
	use doc && java-pkg_dojavadoc docs/api
	use source && java-pkg_dosrc src/*
	dodoc README.txt || die
}

# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A small, extremely fast XML parser for Java"
HOMEPAGE="http://piccolo.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"

EANT_BUILD_TARGET="build"

src_install() {
	java-pkg_dojar lib/Piccolo.jar
	use doc && java-pkg_dojavadoc doc/javadoc
	use source && java-pkg_dosrc src/*
	dodoc README.txt || die
}

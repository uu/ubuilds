# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A small, extremely fast XML parser for Java"
HOMEPAGE="http://piccolo.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc source"

RDEPEND=">=virtual/jre-1.4"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	source? (app-arch/zip)"

src_compile() {
	local anttasks_opt
	use doc && anttasks_opt="javadoc"
	eant build ${anttasks_opt}
}

src_install() {
	java-pkg_dojar lib/Piccolo.jar
	use doc && java-pkg_dojavadoc doc/javadoc
	use source && java-pkg_dosrc src/*
	dodoc README.txt
}

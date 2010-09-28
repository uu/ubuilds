# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="DCD finds dead code in your Java applications."
HOMEPAGE="https://dcd.dev.java.net/"
SRC_URI="https://dcd.dev.java.net/files/documents/8908/97660/${PN}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

COMMON_DEP="
	dev-java/asm:3"

RDEPEND="
	>=virtual/jre-1.6
	${COMMON_DEP}"

DEPEND="
	>=virtual/jdk-1.6
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}"

java_prepare() {
	rm -vf $(find -name \*\.jar) || die
	rm -vf $(find -name \*\.class) || die

	cd "lib/"
	java-pkg_jar-from asm-3 asm.jar asm-3.1.jar
	java-pkg_jar-from asm-3 asm-tree.jar asm-tree-3.1.jar
}

src_install() {
	java-pkg_dojar "${PN}.jar"
	java-pkg_dolauncher "${PN}" --main dcd.ui.DeadCodeDetectorUI

	use doc && java-pkg_dojavadoc doc
	use source && java-pkg_dosrc src/*
}

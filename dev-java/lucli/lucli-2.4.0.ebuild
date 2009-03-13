# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
SLOT=2.4
inherit java-pkg-2 lucene-contrib

DESCRIPTION="lucli (pronounced Luckily) is the Lucene Command Line Interface."
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-java/jline"
RDEPEND="dev-java/jline"
LUCENE_EXTRA_DEPS="jline"

src_install() {
	lucene-contrib_src_install
	java-pkg_dolauncher ${PN}-${SLOT} --main lucli.Lucli
}

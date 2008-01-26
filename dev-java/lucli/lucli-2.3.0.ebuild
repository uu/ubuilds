# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT=2.3
inherit java-pkg-2 lucene-contrib

DESCRIPTION="lucli (pronounced Luckily) is the Lucene Command Line Interface."
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="dev-java/jline"
RDEPEND="dev-java/jline"
DOCS="README"
LUCENE_EXTRA_DEPS="jline"

src_install() {
	lucene-contrib_src_install
	java-pkg_dolauncher ${PN} --main lucli.Lucli
}

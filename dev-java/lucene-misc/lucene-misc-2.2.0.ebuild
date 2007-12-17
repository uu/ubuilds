# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT=2
inherit lucene-contrib

DESCRIPTION="Misc addon for lucene"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_unpack() {
	unpack ${A}
	mv ${S}/contrib/miscellaneous ${S}/contrib/misc
}

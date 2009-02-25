# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT=2.4
inherit lucene-contrib

DESCRIPTION="Misc addon for lucene"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_unpack() {
	lucene-contrib_src_unpack
	mv "${S}"/contrib/miscellaneous "${S}"/contrib/misc
}

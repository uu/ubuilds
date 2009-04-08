# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
SLOT=2.4
inherit lucene-contrib

RESTRICT="test"
#No tests available.

DESCRIPTION="Similarity addon for lucene"
KEYWORDS="~amd64 ~x86"
IUSE=""

pkg_postinst() {
	ewarn "The lucene-similarity package is really just a placeholder, and does
not have any functionality. We recommend the lucene-queries package which
has some document similarity query generators. - We leave this package here
for your information."
}

# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit lucene-contrib

DESCRIPTION="Regex addon for lucene"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-java/jakarta-oro
	=dev-java/jakarta-regexp-1.4*"
RDEPEND="dev-java/jakarta-oro
	 =dev-java/jakarta-regexp-1.4*"

LUCENE_EXTRA_DEPS="jakarta-oro-2.0 jakarta-regexp-1.4"

src_unpack() {
	unpack ${A}
	mkdir -p ${S}/contrib/${LUCENE_MODULE}/lib
}
SLOT=2

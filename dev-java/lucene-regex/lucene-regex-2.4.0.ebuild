# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT=2.4
inherit lucene-contrib

DESCRIPTION="Queries addon for lucene"
KEYWORDS="~amd64 ~x86"
IUSE=""
DOCS="readme.txt"

DEPEND="=dev-java/jakarta-regexp-1.4*"
RDEPEND="=dev-java/jakarta-regexp-1.4*"

LUCENE_EXTRA_DEPS="jakarta-regexp-1.4"

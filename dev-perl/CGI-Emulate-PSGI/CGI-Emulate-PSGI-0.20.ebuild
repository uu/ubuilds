# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=5
inherit perl-module

DESCRIPTION="PSGI adapter for CGI"
#SRC_URI="mirror://cpan/authors/id/P/PG/PGOLLUCCI/${P}.tar.gz"
SRC_URI="mirror://cpan/authors/id/M/MI/MIYAGAWA/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~miyagawa/${P}/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

SRC_TEST="do"

export OPTIMIZE="$CFLAGS"


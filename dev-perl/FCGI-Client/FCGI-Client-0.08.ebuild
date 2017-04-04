# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=5
inherit perl-module

DESCRIPTION="FCGI::Client - client library for fastcgi protocol"
SRC_URI="mirror://cpan/authors/id/T/TO/TOKUHIROM/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~tokuhirom/${P}/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

SRC_TEST="do"

export OPTIMIZE="$CFLAGS"


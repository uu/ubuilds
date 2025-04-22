# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-DBI/Apache-DBI-1.06.ebuild,v 1.9 2007/12/04 20:41:32 corsair Exp $

EAPI=8

inherit perl-module

DESCRIPTION="Convert-Color-Library named lookup of colors from C<Color::Library> "
SRC_URI="mirror://cpan/authors/id/P/PE/PEVANS/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~ruz/Convert-Color-Library/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

SRC_TEST="do"
DEPEND="dev-perl/Color-Library
dev-perl/Convert-Color"

export OPTIMIZE="$CFLAGS"

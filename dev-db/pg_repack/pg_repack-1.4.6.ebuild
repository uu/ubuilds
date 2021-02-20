# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="Reorganize tables in PostgreSQL databases with minimal locks"
HOMEPAGE="http://reorg.github.com/pg_repack"
SRC_URI="http://api.pgxn.org/dist/pg_repack/${PV}/${P}.zip"

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
		dev-db/postgresql[static-libs]"


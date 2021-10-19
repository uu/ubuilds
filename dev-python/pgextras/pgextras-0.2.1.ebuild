# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9,10} )

inherit distutils-r1

DESCRIPTION="Provides various statistics for a Postgres instance"
HOMEPAGE="https://pypi.org/project/pgextras/"
SRC_URI="https://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/prettytable
dev-python/psycopg
dev-python/wcwidth"

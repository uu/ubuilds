# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-app

DESCRIPTION="pgBadger is a PostgreSQL log analyzer."
HOMEPAGE="http://dalibo.github.io/pgbadger/"
SRC_URI="https://github.com/dalibo/pgbadger/archive/v${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/Text-CSV_XS"
RDEPEND="${DEPEND}"

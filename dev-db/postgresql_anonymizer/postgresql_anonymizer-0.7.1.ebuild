# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
POSTGRES_COMPAT=( 9.{5..6} {10..13} )
POSTGRES_USEDEP="server"

inherit postgres-multi


DESCRIPTION="Anonymization & Data Masking for PostgreSQL"
HOMEPAGE="https://gitlab.com/dalibo/postgresql_anonymizer"
SRC_URI="https://gitlab.com/dalibo/${PN}/-/archive/${PV}/${P}.tar.gz"
LICENSE="POSTGRESQL"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="${POSTGRES_DEP}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"


DOCS=( {CHANGELOG,NEWS,README}.md )


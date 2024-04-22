# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

DESCRIPTION="Transparent Data Encryption for PostgreSQL from Percona"
HOMEPAGE="https://github.com/Percona-Lab/pg_tde"
SRC_URI="https://github.com/Percona-Lab/pg_tde/archive/refs/tags/${PV}-alpha.tar.gz"
S="${S}-alpha"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/postgresql"
RDEPEND="${DEPEND}"

src_compile() {
	econf
	emake USE_PGXS=1
}

src_install() {
	pg_libdir=$(pg_config --pkglibdir)
	insinto ${pg_libdir}
	doins pg_tde.so

	pg_shared=$(pg_config --sharedir)
	insinto ${pg_shared}/extension
	doins pg_tde.control
	doins pg_tde--1.0.sql
	dodoc README.md 
}

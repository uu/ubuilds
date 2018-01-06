# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-2

DESCRIPTION="Partitioning tool for PostgreSQL"
HOMEPAGE="http://www.postgrespro.com/blog/pgsql/pg_pathman"
SRC_URI=""
EGIT_REPO_URI="https://github.com/postgrespro/pg_pathman.git"
EGIT_BRANCH="master"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/postgresql:9.5"
RDEPEND="${DEPEND}"


src_compile() {
    emake -j1 USE_PGXS=1
}

src_install() {
	pg_libdir=$(pg_config --pkglibdir)
	insinto ${pg_libdir}
	doins ${PN}.so

	pg_shared=$(pg_config --sharedir)
	insinto ${pg_shared}/extension
	doins ${PN}.control

	doins ${PN}--0.1.sql
   
	dodoc README.md
}

pkg_config() {
	einfo "${PN}.so has to be added to shared_preload_libraries."
	einfo
	einfo "Enable ${PN} by creating an extension with:"
	einfo
	einfo "your_database=# CREATE EXTENSION ${PN};"
	einfo
}

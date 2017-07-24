# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="powa-archivist: the powa PostgreSQL extension"
HOMEPAGE="https://github.com/dalibo/powa-archivist"
SRC_URI=""
EGIT_REPO_URI="https://github.com/dalibo/powa-archivist.git"
EGIT_BRANCH="master"

LICENSE="DALIBO"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/postgresql"
RDEPEND="${DEPEND}"

MY_P="powa"

src_compile() {
    emake USE_PGXS=1
}

src_install() {
	pg_libdir=$(pg_config --pkglibdir)
	insinto ${pg_libdir}
	doins ${MY_P}.so

	pg_shared=$(pg_config --sharedir)
	insinto ${pg_shared}/extension
	doins ${MY_P}.control
	doins ${MY_P}--3.1.1.sql
	
	dodoc README.md
}

pkg_config() {
	einfo "Add to your postgresql.conf :"
	einfo
	einfo "shared_preload_libraries = 'pg_stat_statements,powa'"
	einfo
	einfo "Enable powa by creating an extension with:"
	einfo
	einfo "your_database=# CREATE EXTENSION pg_stat_statements;"
	einfo "your_database=# CREATE EXTENSION btree_gist;"
	einfo "your_database=# CREATE EXTENSION powa;"
	einfo
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-2

DESCRIPTION="A PostgreSQL extension for collecting statistics about predicates, helping find what indices are missing"
HOMEPAGE="https://github.com/dalibo/pg_qualstats"
SRC_URI=""
EGIT_REPO_URI="https://github.com/dalibo/pg_qualstats.git"
EGIT_BRANCH="master"
EGIT_COMMIT="0.0.7"

LICENSE="Ronan Dunklau"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/postgresql:9.4"
RDEPEND="${DEPEND}"

MY_P="pg_qualstats"

src_compile() {
    emake -j1 USE_PGXS=1
}

src_install() {
	pg_libdir=$(pg_config --pkglibdir)
	insinto ${pg_libdir}
	doins ${MY_P}.so

	pg_shared=$(pg_config --sharedir)
	insinto ${pg_shared}/extension
	doins ${MY_P}.control
	doins ${MY_P}--${PV}.sql
}

pkg_config() {
	einfo "Add to your postgresql.conf :"
	einfo
	einfo "shared_preload_libraries = 'pg_stat_statements,pg_qualstats'"
	einfo
	einfo "Enable pg_qualstats by creating an extension with:"
	einfo
	einfo "your_database=# CREATE EXTENSION pg_stat_statements;"
	einfo "your_database=# CREATE EXTENSION pg_qualstats;"
	einfo
}

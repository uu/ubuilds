# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="SQL Firewall Extension for PostgreSQL"
HOMEPAGE="https://github.com/uptimejp/sql_firewall"
SRC_URI=""
EGIT_REPO_URI="https://github.com/uptimejp/sql_firewall.git"
EGIT_BRANCH="master"
EGIT_COMMIT="v0_8"

LICENSE="POSTGRESQL GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/postgresql:9.4"
RDEPEND="${DEPEND}"

MY_P="sql_firewall"

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
	
	dodoc README.${MY_P}
}

pkg_config() {
	einfo
	einfo "Enable firewall by creating an extension with:"
	einfo
	einfo "your_database=# CREATE EXTENSION sql_firewall;"
	einfo
}

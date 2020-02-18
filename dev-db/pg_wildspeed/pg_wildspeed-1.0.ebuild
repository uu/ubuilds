# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="Fast wildcard search for LIKE operator for PostgreSQL 8.4+"
HOMEPAGE="http://sigaev.ru/git/gitweb.cgi?p=wildspeed.git;a=blob;hb=HEAD;f=README.md"
SRC_URI=""
EGIT_REPO_URI="https://sigaev.ru/wildspeed"
#EGIT_BRANCH="master"

LICENSE="POSTGRESQL GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/postgresql"
RDEPEND="${DEPEND}"

MY_P="wildspeed"

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
	
	dodoc README.md
}

pkg_config() {
	einfo
	einfo "Enable ${MY_P} by creating an extension with:"
	einfo
	einfo "your_database=# CREATE EXTENSION ${MY_P};"
	einfo
}

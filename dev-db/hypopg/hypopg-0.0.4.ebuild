# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-2

DESCRIPTION="Hypothetical Indexes support for PostgreSQL"
HOMEPAGE="https://github.com/dalibo/hypopg"
SRC_URI=""
EGIT_REPO_URI="https://github.com/dalibo/hypopg.git"
EGIT_BRANCH="master"
EGIT_COMMIT="5e5c5f3c9082f1f13cd9320f794bfc3aab12cb3b"

LICENSE="DALIBO"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/postgresql:9.4"
RDEPEND="${DEPEND}"

MY_P="hypopg"

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
	einfo "Enable hypopg by creating an extension with:"
	einfo
	einfo "your_database=# CREATE EXTENSION hypopg;"
	einfo
}

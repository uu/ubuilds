# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Hypothetical Indexes support for PostgreSQL"
HOMEPAGE="https://github.com/dalibo/hypopg"
SRC_URI="https://github.com/dalibo/hypopg/archive/${PV}.tar.gz"

LICENSE="DALIBO"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/postgresql"
RDEPEND="${DEPEND}"

MY_P="hypopg"

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

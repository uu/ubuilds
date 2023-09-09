# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit git-r3

DESCRIPTION="Columnar store for analytics with PostgreSQL."
HOMEPAGE="https://github.com/citusdata/cstore_fdw"
SRC_URI=""
EGIT_REPO_URI="https://github.com/citusdata/cstore_fdw.git"
EGIT_BRANCH="master"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/postgresql
	dev-libs/protobuf-c
"
RDEPEND="${DEPEND}"

src_install() {
	pg_libdir=$(pg_config --pkglibdir)
	insinto ${pg_libdir}
	doins ${PN}.so

	pg_shared=$(pg_config --sharedir)
	insinto ${pg_shared}/extension
	doins ${PN}.control
	doins ${PN}--1.3.sql

	dodoc README.md
}


# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="PostgreSQL extension to scale out real-time reads and writes."
HOMEPAGE="https://github.com/citusdata/pg_shard"
SRC_URI=""
EGIT_REPO_URI="https://github.com/citusdata/pg_shard.git"
EGIT_BRANCH="master"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/postgresql"
RDEPEND="${DEPEND}"

src_install() {
	pg_libdir=$(pg_config --pkglibdir)
	insinto ${pg_libdir}
	doins ${PN}.so

	pg_shared=$(pg_config --sharedir)
	insinto ${pg_shared}/extension
	doins ${PN}.control
	doins sql/${PN}.sql
	
	dodoc doc/README.md 
	dobin bin/copy_to_distributed_table
}


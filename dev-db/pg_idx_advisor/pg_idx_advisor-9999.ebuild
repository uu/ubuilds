# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-2 eutils

DESCRIPTION="PostgreSQL extension to scale out real-time reads and writes."
HOMEPAGE="https://github.com/cohenjo/pg_idx_advisor"
SRC_URI=""
EGIT_REPO_URI="git://github.com/cohenjo/pg_idx_advisor.git"
EGIT_BRANCH="master"

LICENSE="POSTGRESQL GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/postgresql"
RDEPEND="${DEPEND}"


src_prepare(){
	epatch "${FILESDIR}/make.patch"
}

src_install() {
	pg_libdir=$(pg_config --pkglibdir)
	insinto ${pg_libdir}
	doins ${PN}.so

	pg_shared=$(pg_config --sharedir)
	insinto ${pg_shared}/extension
	doins ${PN}.control
	doins sql/${PN}--0.1.2.sql
	
	dodoc README.md 
}


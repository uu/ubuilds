# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-2 eutils

DESCRIPTION="CUDA stream for PostgreSQL"
HOMEPAGE="https://github.com/pg-strom/devel"
SRC_URI=""
EGIT_REPO_URI="https://github.com/pg-strom/devel.git"
#EGIT_BRANCH="pgsql9.6"
#EGIT_COMMIT="v0_8"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-db/postgresql-9.5.0
	>=dev-util/nvidia-cuda-toolkit-7.0.28
	>=dev-util/nvidia-cuda-sdk-7.0.28"
RDEPEND="${DEPEND}"


src_prepare() {
	epatch ${FILESDIR}/make.patch
}

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
	doins src/${PN}--1.0.sql
	
	pg_bin=$(pg_config --bindir)
	exeinto ${pg_bin}
	doexe utils/gpuinfo utils/kfunc_info

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


# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit git-r3

DESCRIPTION="Transparent Data Encryption for PostgreSQL"
HOMEPAGE="https://github.com/nec-postgres/tdeforpg"
SRC_URI=""
EGIT_REPO_URI="https://github.com/snaga/tdeforpg.git"
#EGIT_BRANCH="benchmark"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/postgresql"
RDEPEND="${DEPEND}"

src_compile() {
	cd SOURCES
	emake -j1 USE_PGXS=1
}

src_install() {
	pg_libdir=$(pg_config --pkglibdir)
	insinto ${pg_libdir}
	doins SOURCES/data_encryption/data_encryption.so

	pg_shared=$(pg_config --sharedir)
	insinto ${pg_shared}/extension
	doins SOURCES/data_encryption/data_encryption.control
	doins SOURCES/data_encryption/data_encryption--0.1.sql
	newbin SOURCES/bin/cipher_key_regist.sh pg_tde_key.sh

	dodoc README SOURCES/COPYRIGHT SOURCES/INSTALL-NOTE.TXT
}

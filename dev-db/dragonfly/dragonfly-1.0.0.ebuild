# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A modern replacement for Redis and Memcached"
HOMEPAGE="https://dragonflydb.io/"
EGIT_REPO_URI="https://github.com/dragonflydb/dragonfly"
EGIT_COMMIT="v${PV}"
LICENSE="BSL-1.1"
SLOT="0"
KEYWORDS="amd64"

DEPEND="sys-libs/libunwind
dev-libs/libpfm"
RDEPEND="${DEPEND}"
BDEPEND=""
inherit ninja-utils git-r3

src_configure() {
	./helio/blaze.sh -release
}

src_compile() {
	eninja -C build-opt ${PN}
}

src_install() {
	dobin build-opt/${PN}
}


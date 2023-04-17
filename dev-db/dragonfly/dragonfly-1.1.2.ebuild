# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A modern replacement for Redis and Memcached"
HOMEPAGE="https://dragonflydb.io/"
SRC_URI="https://github.com/dragonflydb/dragonfly/releases/download/v${PV}/${PN}-x86_64.tar.gz"
#EGIT_COMMIT="v${PV}"
LICENSE="BSL-1.1"
SLOT="0"
KEYWORDS="amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
S="${WORKDIR}"
QA_PRESTRIPPED="usr/bin/${PN}"
#inherit ninja-utils git-r3

#src_configure() {
#	./helio/blaze.sh -release
#}

#src_compile() {
#	eninja -C build-opt ${PN}
#}

src_install() {
	newbin ${PN}-x86_64 ${PN}
}


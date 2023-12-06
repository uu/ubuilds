# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="A modern replacement for Redis and Memcached"
HOMEPAGE="https://dragonflydb.io/"
SRC_URI="https://github.com/dragonflydb/dragonfly/releases/download/v${PV}/${PN}-x86_64.tar.gz -> ${P}.tar.gz"
LICENSE="BSL-1.1"
SLOT="0"
KEYWORDS="amd64"
IUSE="systemd"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
S="${WORKDIR}"
QA_PRESTRIPPED="usr/bin/${PN}"

src_install() {
	newbin ${PN}-x86_64 ${PN}
	systemd_newunit "${FILESDIR}/${PN}.service" ${PN}.service
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
}


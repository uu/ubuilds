# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Scrapes MooseFS stats and exports them via HTTP for Prometheus consumption"
HOMEPAGE="https://github.com/uu/moosefs_exporter"
SRC_URI="https://github.com/uu/${PN}/releases/download/v${PV}/moosefs_exporter-v${PV}.tar.gz"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DOCS=( LICENSE README.md )
QA_PRESTRIPPED="usr/bin/${PN}"

S="${WORKDIR}/${PN}-v${PV}"


src_install() {
	dobin ${PN}
	einstalldocs

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir /var/log/moosefs_exporter
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd user

DESCRIPTION="Exports metrics from the exim mail server for consumption by Prometheus"
HOMEPAGE="https://prometheus.io"
SRC_URI="https://github.com/gvengel/${PN}/releases/download/v${PV}/${PN}_${PV}_linux_amd64.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DOCS=( README.md )
QA_PRESTRIPPED="usr/bin/exim_exporter"
S="${WORKDIR}"

pkg_setup() {
	enewgroup exim_exporter
	enewuser exim_exporter -1 -1 -1 exim_exporter
}

src_install() {
	dobin exim_exporter
	einstalldocs

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	diropts -o exim_exporter -g exim_exporter -m 0750
	keepdir /var/log/exim_exporter
}

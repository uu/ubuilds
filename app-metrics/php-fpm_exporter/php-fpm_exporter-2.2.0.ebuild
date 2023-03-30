# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd user

DESCRIPTION="A Prometheus exporter that connects directly to PHP-FPM"
HOMEPAGE="https://github.com/hipages/php-fpm_exporter"
SRC_URI="https://github.com/hipages/${PN}/releases/download/v${PV}/${PN}_${PV}_linux_amd64.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DOCS=( README.md )
QA_PRESTRIPPED="usr/bin/php-fpm_exporter"

S=${WORKDIR}

pkg_setup() {
	enewgroup php-fpm_exporter
	enewuser php-fpm_exporter -1 -1 -1 php-fpm_exporter
}

src_install() {
	dobin php-fpm_exporter
	einstalldocs

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	diropts -o php-fpm_exporter -g php-fpm_exporter -m 0750
	keepdir /var/log/php-fpm_exporter
}


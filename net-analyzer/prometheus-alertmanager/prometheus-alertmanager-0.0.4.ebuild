# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit golang-base user

DESCRIPTION="Prometheus Alert Manager"
HOMEPAGE="https://github.com/prometheus/alertmanager"
EGO_PN="github.com/prometheus/alertmanager"
# TODO: Building from source is very experimental. So let's get the binary until there are more stable sources available
SRC_URI="amd64? ( https://${EGO_PN}/releases/download/${PV}/alertmanager-${PV}.linux-amd64.tar.gz )"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"
IUSE=""
DEPEND=">=dev-lang/go-1.5.1"
RDEPEND="${DEPEND}"
DATA_DIR="/var/lib/prometheus"
LOG_DIR="/var/log/prometheus"
DAEMON_USER="prometheus"

pkg_setup() {
	enewuser ${DAEMON_USER} -1 -1 "${DATA_DIR}"
}

src_unpack() {
	default
	mkdir ${P}
	mv alertmanager ${P}/${PN}
}

src_install() {
	dobin "${PN}"

	insinto "/etc/prometheus"
	newins "${FILESDIR}/${PN}.conf" "alertmanager.conf"

	newinitd "${FILESDIR}/${PN}-initd" "${PN}"
	newconfd "${FILESDIR}/${PN}-confd" "${PN}"

  keepdir "${LOG_DIR}"
	fowners "${DAEMON_USER}" "${LOG_DIR}"

	keepdir "${DATA_DIR}/alertmanager"
	fowners "${DAEMON_USER}" "${DATA_DIR}/alertmanager"
}

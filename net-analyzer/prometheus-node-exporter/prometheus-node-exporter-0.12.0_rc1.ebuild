# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit golang-base user

DESCRIPTION="Prometheus exporter for machine metrics."
HOMEPAGE="http://prometheus.io"
SRC_URI="https://github.com/prometheus/node_exporter/archive/${PV/_rc/rc}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
IUSE=""

DEPEND=">=dev-lang/go-1.5
		dev-vcs/mercurial"
RDEPEND="${DEPEND}"

S="${WORKDIR}/node_exporter-${PV/_rc/rc}"

DAEMON_USER="prometheus"
LOG_DIR="/var/log/prometheus"

pkg_setup() {
	enewuser ${DAEMON_USER} -1 -1 -1 "wheel"
}

src_compile() {
    export GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)"
    emake
}

src_install() {
	insinto "/usr/bin"
	newbin "node_exporter" "prometheus-node-exporter"

	newconfd "${FILESDIR}/${PN}-confd" "prometheus-node-exporter"
	newinitd "${FILESDIR}/${PN}-initd" "prometheus-node-exporter"

	keepdir "${LOG_DIR}"
	fowners "${DAEMON_USER}" "${LOG_DIR}"
}

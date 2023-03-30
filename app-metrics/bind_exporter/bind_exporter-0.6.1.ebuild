# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Prometheus exporter for BIND"
HOMEPAGE="https://github.com/digitalocean/bind_exporter"
SRC_URI="https://github.com/prometheus-community/${PN}/releases/download/v${PV}/${P}.linux-amd64.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

COMMON_DEPEND="acct-group/bind_exporter
	acct-user/bind_exporter"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
S="${WORKDIR}/${P}.linux-amd64"

src_install() {
	dobin ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}

pkg_postinst() {
	elog "Make sure BIND was built with libxml2 support. You can check with the"
	elog "following command: named -V | grep libxml2."
	elog "Configure BIND to open a statistics channel. It's recommended to run"
	elog "the bind_exporter next to BIND, so it's only necessary to open a port"
	elog "locally."
	elog ""
	elog "statistics-channels {"
	elog "inet 127.0.0.1 port 8053 allow { 127.0.0.1; };"
	elog "};"
}

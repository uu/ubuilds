# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils systemd user

DESCRIPTION="A libev-based high performance SSL/TLS proxy"
HOMEPAGE="https://hitch-tls.org/"
SRC_URI="https://hitch-tls.org/source/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="dev-libs/openssl:0
		>=dev-libs/libev-4"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /sbin/nologin ${PN}
}

src_install() {
	default
	insinto /etc
	doins "${S}/${PN}.conf.example"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
	systemd_dounit "${FILESDIR}/${PN}.service"
}

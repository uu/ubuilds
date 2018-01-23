# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

KEYWORDS="~amd64"
EGO_PN="github.com/hashicorp/${PN}"
DESCRIPTION="The cluster manager from Hashicorp"
HOMEPAGE="http://www.nomadproject.io"
#SRC_URI="https://github.com/hashicorp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
#SRC_URI="https://releases.hashicorp.com/${PN}/${PV}/${PN}_${PV}_linux_amd64-lxc.zip -> ${P}-lxc.tar.gz"
SRC_URI="lxc? ( https://releases.hashicorp.com/${PN}/${PV}/${PN}_${PV}_linux_amd64-lxc.zip -> ${P}-lxc.zip ) !lxc? ( https://releases.hashicorp.com/${PN}/${PV}/${PN}_${PV}_linux_amd64.zip -> ${P}.zip )"

SLOT="0"
LICENSE="MPL-2.0"
IUSE="lxc"

RESTRICT="strip test"

DEPEND="lxc? ( app-emulation/lxc )"
RDEPEND=""
S="${WORKDIR}"
pkg_setup() {
	enewgroup ${PN}
	enewuser  ${PN} -1 -1 /var/lib/${PN} ${PN}
}

src_install() {
	local x

	#dobin "${S}/src/${EGO_PN}/pkg/linux_amd64$(use lxc && echo '-lxc')/${PN}"
	dobin "${WORKDIR}/${PN}"

	for x in /var/{lib,log}/${PN}; do
		keepdir "${x}"
		fowners ${PN}:${PN} "${x}"
	done

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
}

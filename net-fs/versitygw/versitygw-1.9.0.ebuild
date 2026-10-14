# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8
DESCRIPTION="A simple to deploy but feature rich S3 object storage server for your filesystem"
HOMEPAGE="https://github.com/versity/versitygw"
SRC_URI="https://github.com/versity/versitygw/releases/download/v${PV}/${PN}_v${PV}_Linux_x86_64.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
QA_PRESTRIPPED="usr/bin/${PN}"
inherit systemd
DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}_v${PV}_Linux_x86_64"

src_install() {
	insinto /usr/bin
	dobin ${PN}
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
}

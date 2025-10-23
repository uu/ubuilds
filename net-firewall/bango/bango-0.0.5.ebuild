# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8
#inherit eutils
DESCRIPTION="Distributed banning system for fail2ban"
HOMEPAGE="https://github.com/uu/bango"
SRC_URI="https://github.com/uu/bango/releases/download/v${PV}/bango-v${PV}.tar.gz"
LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
QA_PRESTRIPPED="usr/bin/${PN}"

DEPEND="net-analyzer/fail2ban"
RDEPEND="${DEPEND}"
MY_V="v${PV}"
#WORKDIR="${S}/${MY_V}"
S="${WORKDIR}/${PN}-${MY_V}"

src_install() {
	insinto /usr/bin
	dobin ${PN}
	insinto /etc
	doins ${PN}.ini
	newinitd ${FILESDIR}/init ${PN}
	insinto /etc/fail2ban/action.d/
	doins actions/${PN}.conf
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Release manager agent"
HOMEPAGE="https://megaplan.ru"
SRC_URI="${P}.tar.bz2"

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
S=${WORKDIR}/${PN}

inherit eutils

src_install() {
#enewuser deploy
	dodir /opt/${PN}
	dodir /var/log/${PN}
	fowners post /var/log/${PN}
	insinto /opt/${PN}
	doins *
	newinitd "${FILESDIR}/${PN}.init" ${PN} || die
}

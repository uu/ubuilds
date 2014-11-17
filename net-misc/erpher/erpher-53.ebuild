# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils
DESCRIPTION="ERlang PHp workER"
HOMEPAGE="http://megaplan.ru"


LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="rabbitmq"
RESTRICT="strip"

SRC_URI=" rabbitmq? ( http://www.alx-xc.ru/erpher/erpher-lin64-${PV}.tgz )
		  !rabbitmq? ( http://www.alx-xc.ru/erpher/erpher-lin64-${PV}-worabbit.tgz )
		  "

S=${WORKDIR}/${PN}
DEPEND=""
RDEPEND="${DEPEND}"

pkg_setup() {
    ebegin "Creating ${PN} user and group"
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /home/${PN} ${PN}
}

src_prepare() {
	 sed -e "s:%ROOT%:/opt/${PN}:" etc/app.config.tmpl > etc/app.config || die
}

src_install() {
	dodir /opt/${PN}
	cp -a "${S}/" "${D}/opt/" || die "Install failed!"
	chown -R ${PN}:${PN} ${D}/opt/${PN}
	newinitd ${FILESDIR}/erpher.init ${PN}
	newconfd ${FILESDIR}/erpher.conf ${PN}
}

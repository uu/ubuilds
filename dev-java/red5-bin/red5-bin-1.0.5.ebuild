# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit eutils user

MY_P=${P/_/}
S=${WORKDIR}/red5-server-${PV}-RELEASE

DESCRIPTION="Open Source Flash Server written in Java"
HOMEPAGE="http://code.google.com/p/red5/"
SRC_URI="http://www.red5.org/downloads/red5/1_0/red5-${PV}.tar.gz"
SRC_URI="https://github.com/Red5/red5-server/releases/download/v${PV}-RELEASE/red5-server-${PV}-RELEASE-server.tar.gz"
LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=virtual/jdk-1.5
	>=dev-java/ant-core-1.5"
RDEPEND=">=virtual/jdk-1.5"

RED5_HOME=/opt/red5

pkg_setup() {
	enewgroup red5
	enewuser red5 -1 -1 ${RED5_HOME} red5
}


src_install() {
	newinitd "${FILESDIR}"/red5.initd red5
	newconfd "${FILESDIR}"/red5.confd red5
	doenvd "${FILESDIR}"/21red5

	dodir ${RED5_HOME}
	cp -a * ${D}${RED5_HOME}
	fowners -R red5:red5 ${RED5_HOME}
	fperms 0750 ${RED5_HOME}/red5.sh
	dosym ${RED5_HOME}/webapps /var/lib/red5-webapps
}

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit user

DESCRIPTION="Apache ActiveMQ is the most popular and powerful open source messaging and Integration Patterns server"
HOMEPAGE="https://activemq.apache.org"
#SRC_URI="http://apache-mirror.rbc.ru/pub/apache/activemq/apache-activemq/${PV}/${PN}-${PV}-bin.tar.gz"
SRC_URI="http://apache-mirror.rbc.ru/pub/apache/activemq/5.13.0/apache-activemq-${PV}-bin.tar.gz"
#MY_PN="${PN/-bin/}"
#SRC_URI="mirror://apache/${MY_PN}/apache-${MY_PN}/${PV}/${P}-bin.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="virtual/jre"
RDEPEND="${DEPEND}"

src_install() {
	dodoc	README.txt NOTICE || die

	sed -i 's:log4j.rootLogger=INFO, console, logfile:log4j.rootLogger=INFO, console:' ${S}/conf/log4j.properties || die

	dodir	/opt/${PN} || die
	cp -a ${S}/* ${D}/opt/${PN} || die "install failed!"

	newinitd ${FILESDIR}/activemq.init activemq || die
	newconfd ${FILESDIR}/activemq.conf activemq || die
}

pkg_preinst() {
	enewgroup activemq
	enewuser activemq -1 /bin/sh /opt/${PN} activemq -r
}


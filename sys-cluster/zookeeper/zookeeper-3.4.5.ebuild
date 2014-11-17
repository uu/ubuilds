# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5


DESCRIPTION="ZooKeeper is a distributed, open-source coordination service for distributed applications."
HOMEPAGE="http://zookeeper.apache.org"
SRC_URI="http://apache-mirror.rbc.ru/pub/apache/zookeeper/zookeeper-${PVR}/zookeeper-${PVR}.tar.gz -> ${PF}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="!dev-libs/libzookeeper virtual/jre"
RDEPEND="${DEPEND}"

inherit eutils

src_configure() {
	cd ${S}/src/c
	if [[ -x ${ECONF_SOURCE:-.}/configure ]] ; then
		econf
	fi
}

src_compile() {
	cd ${S}/src/c
	if [ -f Makefile ] || [ -f GNUmakefile ] || [ -f makefile ]; then
		emake || die "emake failed"
	fi
}

src_install() {
    dodoc README.txt CHANGES.txt || die
	mkdir -p ${D}/opt/${PN} || die
	cp -a ${WORKDIR}/$PF/* ${D}/opt/${PN} || die
	newconfd ${FILESDIR}/zookeeper.confd ${PN}|| die
	newinitd ${FILESDIR}/zookeeper.initd ${PN} || die
	sed -i "s:version=.*:version=\"${PVR}\":g" ${D}/etc/conf.d/${PN}
	cp -a ${FILESDIR}/zookeeper.cfg ${D}/etc/ || die
	if [ -d ${ROOT}/etc/logrotate.d ];then
		mkdir ${D}/etc/logrotate.d || die
		cp -a ${FILESDIR}/zookeeper.logrotate ${D}/etc/logrotate.d/zookeeper || die
	fi
	#	install headers for c client compilation
	cd ${S}/src/c
	emake DESTDIR="${D}" install || die "Install failed"
	cp -a ${S}/src/c/generated/zookeeper.jute.h ${S}/src/c/include/ || die
	mkdir -p ${D}/usr/include/zookeeper || die
	cp -a ${S}/src/c/include/* ${D}/usr/include/zookeeper/ || die
}

pkg_preinst() {
    enewgroup zookeeper
    enewuser zookeeper -1 /bin/sh /opt/${PN} zookeeper -r
	mkdir	-p ${ROOT}/var/db/${PN}
	chown	-R zookeeper. ${ROOT}/var/db/${PN}
}

pkg_postinst() {
	elog "Apache Zookeeper installed to the /opt dir."
	elog "Zookeeper config file you can find here: /etc/zookeeper.cfg"
	elog "Default database dir is: /var/db/zookeeper and can be changed in the
	/etc/conf.d/zookeeper config file"
	elog "Have fun! :)"
}

pkg_prerm() {
    # clean up temp files
    [[ -d "${ROOT}/var/db/${PN}" ]] && rm -rf "${ROOT}/var/db/${PN}"
}


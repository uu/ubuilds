# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Zookeeper C client module."
HOMEPAGE="zookeeper.apache.org"
SRC_URI="http://apache-mirror.rbc.ru/pub/apache/zookeeper/zookeeper-${PVR}/zookeeper-${PVR}.tar.gz -> ${PF}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="!sys-claster/zookeeper"
RDEPEND="${DEPEND}"

src_unpack() {
    if [ "${A}" != "" ]; then
        unpack ${A}
		mv ${WORKDIR}/zookeeper-${PV} ${WORKDIR}/${P}
    fi
}

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
	cd ${S}/src/c
    emake DESTDIR="${D}" install || die "Install failed"
	cd ${S}
    dodoc README.txt CHANGES.txt || die
	cp -a ${S}/src/c/generated/zookeeper.jute.h ${S}/src/c/include/
	mkdir -p ${D}/usr/include/zookeeper
	cp -a ${S}/src/c/include/* ${D}/usr/include/zookeeper/
}


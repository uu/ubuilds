# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Client and server for running commands via redis pub/sub."
HOMEPAGE="https://github.com/uu/crash"
SRC_URI="https://github.com/uu/crash/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
QA_PRESTRIPPED="usr/sbin/crash"

src_compile() {
	true
}

src_install() {

	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}

	insinto /etc
	doins dist/${PN}.ini

	dosbin dist/${PN}
}



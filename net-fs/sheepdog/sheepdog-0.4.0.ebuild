# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit bash-completion autotools eutils

DESCRIPTION="Distributed Storage System for KVM."
HOMEPAGE="http://www.osrg.net/sheepdog/"
SRC_URI="${P}.tar.gz"
SRC_URI="https://nodeload.github.com/collie/sheepdog/tarball/v0.4.0 -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sys-cluster/corosync
		dev-libs/userspace-rcu
	|| ( >=app-emulation/qemu-kvm-0.13 >=app-emulation/qemu-0.13 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
S="${WORKDIR}/collie-sheepdog-6787553"
src_compile(){
	eautoreconf
	econf
	emake
}
src_install() {
	# default make install is stupid
    dosbin collie/collie sheep/sheep
    doman man/*.8
    dodoc README
    dobashcompletion script/bash_completion_collie ${PN}-collie
    keepdir /var/lib/sheepdog
    newinitd "${FILESDIR}/${PN}.initd" ${PN}
    newconfd "${FILESDIR}/${PN}.confd" ${PN}
}

pkg_postinst() {
	elog "Make sure that the storage path (default: '/var/lib/sheepdog')"
	elog "lies on a filesystem with extended attributes (xattr) support."
}

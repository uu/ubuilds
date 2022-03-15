# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

EAPI=6

inherit eutils autotools cmake-utils user

DESCRIPTION="LizardFS is an Open Source Distributed File System licenced under GPLv3."
HOMEPAGE="http://lizardfs.org"
SRC_URI="https://github.com/lizardfs/lizardfs/archive/refs/tags/${PV}-rc3.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="cgi +fuse fuse3 static-libs -devel"
S="${S}-rc3"
RDEPEND="
	cgi? ( dev-lang/python )
	!sys-cluster/moosefs
	dev-libs/judy
	dev-libs/spdlog
	fuse? ( >=sys-fs/fuse-2.6 )
	fuse3? ( >=sys-fs/fuse-3.2 )
	dev-libs/isa-l
	>=sys-devel/gcc-6.3.0"
DEPEND="${RDEPEND}"

src_prepare() {
	eapply ${FILESDIR}/iostat_header.patch
	eapply ${FILESDIR}/lizardfs-cstdio-header.patch
	default
}

pkg_setup() {
	enewgroup mfs
	enewuser mfs -1 -1 -1 mfs
	mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DENABLE_TESTS=NO
		-DENABLE_DOCS=NO
		-DENABLE_JEMALLOC=YES
		-DENABLE_POLONAISE=OFF
		-DTHROW_INSTEAD_OF_ABORT=YES
		-DCMAKE_INSTALL_PREFIX=/
		-Wno-dev
	)

if use devel; then
  mycmakeargs+=( -DENABLE_CLIENT_LIB=YES )
fi
}

src_install() {
	cmake-utils_src_install

	newinitd "${FILESDIR}/mfs.initd" mfs
	newconfd "${FILESDIR}/mfs.confd" mfs
	if use cgi; then
		newinitd "${FILESDIR}/mfscgiserver.initd" mfscgiserver
		newconfd "${FILESDIR}/mfscgiserver.confd" mfscgiserver
	fi

	diropts -m0750 -o mfs -g mfs
	dodir "/var/lib/mfs"
	#mv "${D}usr/var/lib/mfs/*" "${D}/var/lib/mfs"
	chown -R mfs:mfs "${D}var/lib/mfs" || die
	chmod 750 "${D}var/lib/mfs" || die
}


# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/moosefs/moosefs-1.6.25.ebuild,v 1.1 2012/07/02 13:51:07 ultrabug Exp $

EAPI=5

inherit eutils git-r3 autotools cmake-utils user

MY_P="mfs-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="LizardFS is an Open Source Distributed File System licenced under GPLv3."
HOMEPAGE="http://lizardfs.org"
SRC_URI=""

EGIT_REPO_URI="https://github.com/lizardfs/lizardfs.git"
#EGIT_COMMIT="If316525daf78165494416508cb81b5448f3b760d"
EGIT_COMMIT="v3.12.0"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="cgi +fuse static-libs -devel"

RDEPEND="
	cgi? ( dev-lang/python )
	!sys-cluster/moosefs
	app-text/asciidoc
	dev-libs/judy
	fuse? ( >=sys-fs/fuse-2.6 )"
DEPEND="${RDEPEND}"


pkg_setup() {
	enewgroup mfs
	enewuser mfs -1 -1 -1 mfs
mycmakeargs="-DCMAKE_BUILD_TYPE=Release -DENABLE_TESTS=NO -DCMAKE_INSTALL_PREFIX=/ -DENABLE_DEBIAN_PATHS=YES"

if use devel; then
  mycmakeargs+=" -DENABLE_CLIENT_LIB=YES"
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


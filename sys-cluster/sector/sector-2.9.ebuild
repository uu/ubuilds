# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/repmgr/repmgr-9999.ebuild,v 1.1 2012/09/10 15:10:25 uu Exp $
EAPI=4

inherit eutils

DESCRIPTION="Sector/Sphere High Performance Distributed File System and Parallel Data Processing Engine"

HOMEPAGE="http://sector.sf.net/"
SRC_URI=""
SRC_URI="http://downloads.sourceforge.net/project/${PN}/SECTOR/${PV}/${PN}.${PV}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="fuse"
GCC_UNNEEDED="4.7"
RDEPEND=""
RDEPEND="fuse? ( sys-fs/fuse )"
DEPEND=""
S="${WORKDIR}/sector-sphere"
MAKEOPTS="-j1"


src_prepare() {
	GCC_VER="$(gcc-version)"
	if version_is_at_least ${GCC_UNNEEDED} ${GCC_VER}; then
  	  die "${PN} does not compile with gcc-${GCC_VER}"
	fi
}

src_compile() {
	emake
	if use fuse; then
	  cd fuse && make
	fi
}

src_install() {
  if use fuse; then
  	dosbin ${S}/fuse/sector-fuse
  fi
  dosbin ${S}/master/start_all
  dosbin ${S}/master/start_master
  dosbin ${S}/master/stop_all
  dosbin ${S}/slave/start_slave
  dosbin ${S}/security/sserver
  dosbin ${S}/security/ssl_cert_gen
  dosbin ${S}/tools/sector_*
  dolib.so  ${S}/lib/*.so
  dodir /etc/sector
  dodir /etc/sector/users
  insinto /etc/sector
  doins conf/*
  insinto /etc/sector/users
  doins conf/users/*
}

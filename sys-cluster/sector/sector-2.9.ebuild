# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/repmgr/repmgr-9999.ebuild,v 1.1 2012/09/10 15:10:25 uu Exp $
EAPI=5

inherit eutils versionator

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
  dodir /opt/sector
  dodir /opt/sector/{master,lib,slave,security,tools,conf}
  dodir /opt/sector/conf/users
  insopts -m755
  insinto /opt/sector/master
  doins ${S}/master/start_all
  doins ${S}/master/start_master
  doins ${S}/master/stop_all
  insinto /opt/sector/slave
  doins ${S}/slave/start_slave
  insinto /opt/sector/security
  doins ${S}/security/sserver
  doins ${S}/security/ssl_cert_gen
  insinto /opt/sector/tools
  doins ${S}/tools/sector_*
  doins ${S}/tools/sphere_*
  insinto /opt/sector/lib
  doins  ${S}/lib/*.so
  insinto /opt/sector/conf
  doins conf/*
  insinto /opt/sector/conf/users
  doins conf/users/*
}

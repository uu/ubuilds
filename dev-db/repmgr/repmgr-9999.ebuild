# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/repmgr/repmgr-9999.ebuild,v 1.1 2012/09/10 15:10:25 uu Exp $
EAPI=4

inherit distutils git-2 versionator eutils

DESCRIPTION="PostgreSQL Replication Manager"

HOMEPAGE="http://www.repmgr.org/"
EGIT_REPO_URI="git://github.com/2ndQuadrant/repmgr.git"
SRC_URI=""
#SRC_URI="http://downloads.sourceforge.net/project/pgbarman/${PV}/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="virtual/pam
	dev-libs/libxslt
	net-misc/rsync
	dev-db/postgresql-server"
DEPEND=""



src_compile() {
 make USE_PGXS=1
}

src_install() {
  export PGSLOT="$(postgresql-config show)"
  einfo "PGSLOT: ${PGSLOT}"
  dodir /usr/share/postgresql-${PGSLOT}/contrib/
  insinto /usr/share/postgresql-${PGSLOT}/contrib/
  doins sql/repmgr_funcs.sql repmgr.sql sql/uninstall_repmgr_funcs.sql uninstall_repmgr.sql 
  fowners postgres:postgres /usr/share/postgresql-${PGSLOT}/contrib/*
  dobin repmgr repmgrd
  dodoc  CREDITS COPYRIGHT README.rst LICENSE TODO
  insinto /etc
  newins repmgr.conf.sample repmgr.conf
  fowners postgres:postgres /etc/repmgr.conf
  ewarn "Remember to modify /etc/repmgr.conf"
}

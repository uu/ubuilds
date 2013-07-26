# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Raider is a tool to automate linux software raid conversion."
HOMEPAGE="http://raider.sourceforge.net/"
SRC_URI="http://switch.dl.sourceforge.net/project/raider/${P}.tar.gz"

LICENSE="GPL2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

inherit eutils

src_prepare() {
	echo `pwd`
#	epatch -p1 ${FILESDIR}/install.patch
	patch -p0  -R -g0 -E --no-backup-if-mismatch < ${FILESDIR}/install.patch
}

src_install() {
	echo ${D}
	dodir /usr/bin/
	diropts -m 777
	dodir /var/log/raider
	cd ${S} && PREFIX=${D}/usr/bin/ LIBDIR=${D}/usr/lib/ CACHEDIR=${D}/var/lib/raider/ ./install.sh
}

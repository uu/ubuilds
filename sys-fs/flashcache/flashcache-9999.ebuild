# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/flashcache/flashcache-9999.ebuild,v 1.0 2012/09/12 13:53:17 uu Exp $

EAPI=4

inherit eutils git-2 linux-mod linux-info

EGIT_REPO_URI="git://github.com/facebook/flashcache.git"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="FlashCache provides a way to use a SSD as a cache for slower disks"
HOMEPAGE="http://www.github.com/facebook/flashcache"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

MODULE_NAMES="flashcache(misc:${S}/src)"
RDEPEND="dev-vcs/git"
DEPEND="${RDEPEND}"

CONFIG_CHECK="MD BLK_DEV_DM DM_UEVENT"

src_compile() {
	sed -i '/COMMIT_REV/d' Makefile
    MAKEOPTS="-j1"
	BUILD_TARGETS=" "
    linux-mod_src_compile
}

src_install() {
	KV_OBJ="ko"
    docinto
    dodoc README || die
    dodoc  ${S}/doc/flashcache-sa-guide.txt ${S}/doc/flashcache-doc.txt
    linux-mod_src_install
    dosbin "${S}/src/utils/flashcache_create" || die "install failed"
    dosbin "${S}/src/utils/flashcache_destroy" || die "install failed"
    dosbin "${S}/src/utils/flashcache_load" || die "install failed"
}

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: repos/ubuilds/net-misc/cloudfuse/cloudfuse-9999.ebuild,v 1.0 2012/05/29 15:25:58 uu Exp$

EAPI=5

DESCRIPTION="Fuse cloud system for use with any Swift"
HOMEPAGE="https://github.com/redbo/cloudfuse"
EGIT_REPO_URI="https://github.com/vfloz/cloudfuse.git"

LICENSE=""
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=" dev-libs/libxml2
		 net-misc/curl
		 dev-libs/openssl
		 sys-fs/fuse"
RDEPEND="${DEPEND}"

inherit git-r3


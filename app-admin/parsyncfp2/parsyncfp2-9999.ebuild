# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
inherit git-r3 eutils autotools
DESCRIPTION="MultiHost parallel rsync wrapper"
HOMEPAGE="https://github.com/hjmangalam/parsyncfp2"
SRC_URI=""
EGIT_REPO_URI="https://github.com/hjmangalam/parsyncfp2.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
DEPEND="sys-apps/ethtool
net-misc/iputils
dev-perl/scut
app-admin/fpart"

RDEPEND="${DEPEND}"

src_install() {
	dobin ${PN}
}

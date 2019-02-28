# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: repos/ubuilds/net-misc/cloudfuse/cloudfuse-9999.ebuild,v 1.0 2012/05/29 15:25:58 uu Exp$

EAPI=7

DESCRIPTION="Bash script for upload file to cloud storage based on OpenStack Swift API."
HOMEPAGE="https://github.com/selectel/supload"
EGIT_REPO_URI="https://github.com/selectel/supload.git"

LICENSE=""
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="net-misc/curl
		sys-apps/file"
RDEPEND="${DEPEND}"

inherit git-r3

src_install(){
	newbin ${PN}.sh ${PN}
}

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Real dmesg timestamps"
HOMEPAGE="https://github.com/uu/rdmesg"
EGIT_REPO_URI="https://github.com/uu/rdmesg.git"
SRC_URI=""

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
inherit git-2

src_install() {
	exeinto /usr/bin
	doexe rdmesg
}

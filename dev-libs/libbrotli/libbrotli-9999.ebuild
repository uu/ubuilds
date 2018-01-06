# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs git-r3 autotools

DESCRIPTION="Meta project to build libraries from the brotli source code"
HOMEPAGE="https://github.com/bagder/libbrotli"
EGIT_REPO_URI="https://github.com/bagder/libbrotli"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
REQUIRED_USE=""

DOCS=( README.md )

src_prepare() {
	eautoreconf
	eapply_user
}


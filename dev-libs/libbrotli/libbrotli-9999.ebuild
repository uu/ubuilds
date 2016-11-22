# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

#PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy )
#DISTUTILS_OPTIONAL="1"

inherit toolchain-funcs git-r3 autotools

DESCRIPTION="Meta project to build libraries from the brotli source code"
HOMEPAGE="https://github.com/bagder/libbrotli"
EGIT_REPO_URI="git://github.com/bagder/libbrotli"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
REQUIRED_USE=""

DOCS=( README.md )

src_prepare() {
	eautoreconf
#	sed -i "s/-O2/\$(CUSTOM_CFLAGS)/g" Makefile || die
	eapply_user
}

#src_configure() {
#	eautoconf
#	use python && distutils-r1_src_configure
#}

#src_compile() {
#	tc-export CC
#	emake bro lib CUSTOM_CFLAGS="${CFLAGS}"
#
#	use python && distutils-r1_src_compile
#}

#src_install() {
#	insinto /usr/include
#	doins -r brotli/include/*
#	dolib.a libbrotli.a # No shared library is currently provided
#
#	use python && distutils-r1_src_install
#
#	use doc && dodoc docs/*
#}

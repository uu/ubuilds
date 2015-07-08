# Copyright 2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

ESVN_REPO_URI="http://libyuv.googlecode.com/svn/branches/m34"
ESVN_PROJECT="libyuv"

inherit subversion

DESCRIPTION="libyuv is an open source project that includes YUV scaling and conversion functionality"
HOMEPAGE="http://code.google.com/p/libyuv/"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""

RDEPEND=${DEPEND}

src_prepare() {
	cp ${FILESDIR}/build.sh ${S}/build.sh
}

src_compile() {
	./build.sh
}

src_install() {
	mkdir -p ${D}/usr/include
	mkdir -p ${D}/usr/lib
	cp -r ${S}/include/* ${D}/usr/include/
	cp ${S}/libyuv.so ${D}/usr/lib/
}

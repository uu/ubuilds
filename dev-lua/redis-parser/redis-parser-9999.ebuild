# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils toolchain-funcs git-r3

DESCRIPTION="Redis reply parser and request constructor library for Lua"
HOMEPAGE="https://github.com/openresty/lua-${PN}"
SRC_URI=""

EGIT_REPO_URI="https://github.com/openresty/lua-${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	virtual/lua[luajit=]
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	local lua=lua;
        use luajit && lua=luajit;

	sed -r \
		-e "s#^(PREFIX).*#\1=/usr#" \
		-e "s#^(LUA_LIB_DIR).*#\1=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})#" \
		-e "s#^(LUA_INCLUDE_DIR).*#\1=$($(tc-getPKG_CONFIG) --variable includedir ${lua})#" \
		-i Makefile
}

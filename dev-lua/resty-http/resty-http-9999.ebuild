# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils toolchain-funcs git-r3

DESCRIPTION="Lua HTTP client cosocket driver for OpenResty / ngx_lua"
HOMEPAGE="https://github.com/pintsized/lua-${PN}"
SRC_URI=""

EGIT_REPO_URI="https://github.com/pintsized/lua-${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="luajit"

RDEPEND="
	virtual/lua[luajit=]
	www-servers/nginx[nginx_modules_http_lua]
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_install() {
	local lua=lua;
	use luajit && lua=luajit;

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	doins -r lib/resty
}

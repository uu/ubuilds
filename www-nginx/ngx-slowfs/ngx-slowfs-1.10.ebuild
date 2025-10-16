# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8


NGINX_MOD_S="${WORKDIR}/ngx_slowfs_cache-${PV}"
inherit nginx-module

DESCRIPTION="NGINX module adding ability to cache static files."
HOMEPAGE="http://labs.frickle.com/nginx_ngx_slowfs_cache/"
SRC_URI="
	http://labs.frickle.com/files/ngx_slowfs_cache-${PV}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64"

BDEPEND="virtual/pkgconfig"
DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/http_slowfs_cache-1.23.0.patch"
	"${FILESDIR}/http_slowfs_cache-module.patch"
)

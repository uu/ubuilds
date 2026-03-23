# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit nginx-module

S="${WORKDIR}/mod_zip-${PV}"

DESCRIPTION="Streaming ZIP archiver for nginx"
HOMEPAGE="https://github.com/evanmiller/mod_zip"
SRC_URI="https://github.com/evanmiller/mod_zip/archive/refs/tags/${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64"

BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/mod-zip-crc.patch"
	"${FILESDIR}/mod-zip-order.patch"
)

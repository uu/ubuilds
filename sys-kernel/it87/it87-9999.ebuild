# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info linux-mod eutils git-r3

DESCRIPTION="Linux Driver for ITE LPC chips"
HOMEPAGE="https://github.com/groeck/it87"
SRC_URI=""
EGIT_REPO_URI="https://github.com/groeck/it87"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

MODULE_NAMES="it87(hwmon:${S})"
BUILD_TARGETS="modules"

CONFIG_CHECK="!IT87"
ERROR_IT87="${P} requires original IT87 to be disabled"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
)

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KERNELDIR=${KV_DIR}"
}

src_install() {
	linux-mod_src_install
	dodoc README
}

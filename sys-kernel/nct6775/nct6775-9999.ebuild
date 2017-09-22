# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info linux-mod eutils git-r3

DESCRIPTION="New driver for Nuvoton NCT6775F, NCT6776F, NCT6779D"
HOMEPAGE="https://github.com/groeck/nct6775"
SRC_URI=""
EGIT_REPO_URI="https://github.com/groeck/nct6775"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

MODULE_NAMES="nct6775(hwmon:${S})"
BUILD_TARGETS="modules"

CONFIG_CHECK="!SENSORS_NCT6775"
ERROR_SENSORS_IT87="${P} requires original NCT6775 to be disabled"

PATCHES=(
		${FILESDIR}/makefile.patch
		)


pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KERNELDIR=${KV_DIR}"
}

src_install() {
	linux-mod_src_install
	dodoc README
}

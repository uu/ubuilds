# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit eutils versionator

SLOT="$(get_major_version)"
RDEPEND=">=virtual/jdk-1.6"

RESTRICT="strip"

DESCRIPTION="YourKit java profiling tool"
HOMEPAGE="http://www.yourkit.com/download/"
VERSTRING="$(get_major_version)-build-$(get_version_component_range 2-2)"
SRC_URI="http://www.yourkit.com/download/yjp-${VERSTRING}-linux.tar.bz2"
LICENSE="yourkit"
IUSE=""
KEYWORDS="~x86 ~amd64"
S="${WORKDIR}/yjp-${VERSTRING}"
INSTALL_DIR="/opt/${PN}-${PV}"

src_install() {
    insinto "${INSTALL_DIR}"
    doins -r bin lib  license.html  license-redist.txt  probes  samples

    fperms 755 ${INSTALL_DIR}/bin/yjp.sh
    make_wrapper "${PN}-${PV}" "${INSTALL_DIR}/bin/yjp.sh"
    newicon "bin/yjp.ico" "${PN}-${PV}.ico"
    make_desktop_entry "${PN}-${PV}" "YourKit ${PV}" "${PN}-${PV}" "Development;Profiling"
}

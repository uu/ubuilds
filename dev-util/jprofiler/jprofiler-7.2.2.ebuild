# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit eutils versionator

SLOT="$(get_major_version)"
RDEPEND=">=virtual/jdk-1.6"

RESTRICT="strip"

DESCRIPTION="JProfiler java profiling tool"
HOMEPAGE="http://www.ej-technologies.com/products/jprofiler/overview.html"
SRC_URI="http://download-aws.ej-technologies.com/jprofiler/jprofiler_linux_${PV//./_}.tar.gz"
LICENSE="jprofiler"
IUSE=""
KEYWORDS="~x86 ~amd64"
S="${WORKDIR}/jprofiler${SLOT}"
INSTALL_DIR="/opt/${PN}-${PV}"

src_install() {
    insinto "${INSTALL_DIR}"
    doins -r * .install4j

    fperms 755 ${INSTALL_DIR}/bin/jprofiler
    make_wrapper "${PN}" "${INSTALL_DIR}/bin/jprofiler"
    newicon ".install4j/i4j_extf_3_198c2a3_8mtf09.png" "${PN}.png"
    make_desktop_entry "${PN}" "JProfiler" "${PN}" "Development;Profiling"
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ARCHIVE_URI="https://github.com/blablacar/dgr/releases/download/v${PV}/${PN}-v${PV}-linux-amd64.tar.gz -> dgr-${PV}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Container build and runtime tool"
HOMEPAGE="https://github.com/blablacar/dgr"
SRC_URI="${ARCHIVE_URI}"
S="${WORKDIR}/dgr-v90-linux-amd64/"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=""

RESTRICT="test"

src_install() {
#	pushd src/${EGO_PN} || die
	dobin ${PN}
#

#	popd || die
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="Reliable MTP client with minimalistic UI"
HOMEPAGE="https://whoozle.github.io/android-file-transfer-linux/"
SRC_URI="https://github.com/whoozle/${PN}/archive/v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fuse +qt5"
REQUIRED_USE="qt5"

RDEPEND="fuse? ( sys-fs/fuse )
	qt5? ( dev-qt/qtwidgets:5 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DBUILD_FUSE=$(usex fuse)
		-DBUILD_QT_UI=$(usex qt5)
		-DUSB_BACKEND_LIBUSB=OFF
	)
	cmake-utils_src_configure
}

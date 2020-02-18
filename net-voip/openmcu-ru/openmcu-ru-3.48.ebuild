# Copyright 2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="https://github.com/muggot/openmcu.git"
EGIT_PROJECT="openmcu-ru-${PV}"
EGIT_BRANCH="3.48"

inherit eutils git-r3

DESCRIPTION="OpenMCU-ru is a simple Mutli Conference Unit using the H.323 and SIP protocol"
HOMEPAGE="http://openmcu.ru/"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="libyuv"

DEPEND="
	>=media-video/ffmpeg-0.10
	media-libs/x264
	>=media-libs/libvpx-1.0
	media-libs/freetype
	media-libs/libjpeg-turbo
	media-libs/opus
	>=net-libs/sofia-sip-1.12.11
	libyuv? ( media-libs/libyuv )"
RDEPEND=${DEPEND}

INSTALL_DIR="/usr"

src_prepare() {
    epatch "${FILESDIR}"/web_stream_start-3.48.patch
    sed -i -e 's|ldconfig -v|ldconfig -r|g' configure.ac
    ./autogen.sh
}

src_configure() {
	econf \
		--prefix=${INSTALL_DIR} \
		$(use_enable libyuv optimized-frame-resize) \
		|| die
}

src_install() {
	emake DESTDIR=${D} install || die

	echo CONFIG_PROTECT=${INSTALL_DIR}/share/openmcu-ru/config > ${T}/99${PN}
	doenvd "${T}"/99${PN}

	newinitd "${FILESDIR}/openmcu-ru-3.48.initd" openmcu-ru
}

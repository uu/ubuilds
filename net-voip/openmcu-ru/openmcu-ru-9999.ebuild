# Copyright 2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="https://github.com/muggot/openmcu.git"
EGIT_PROJECT="openmcu-ru-${PV}"
#github not access
EVCS_OFFLINE=True
#v3.49.19
#EGIT_COMMIT="95545c1afe495757dac8f6ca299f482084a17b07"

inherit eutils git-2

DESCRIPTION="OpenMCU-ru is a simple Mutli Conference Unit using the H.323 and SIP protocol"
HOMEPAGE="http://openmcu.ru/"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="libjpeg-browser zrtp"

DEPEND="
	>=media-video/ffmpeg-0.10
	media-libs/x264
	>=media-libs/libvpx-1.0
	media-libs/freetype
	media-libs/libjpeg-turbo
	media-libs/opus
	media-libs/libmp4v2"
	#libjpeg-browser? ( media-libs/libjpeg-turbo )"
RDEPEND=${DEPEND}

INSTALL_DIR="/opt"

src_prepare() {
    epatch "${FILESDIR}"/web_stream_start-git.patch
    sed -i -e 's|ldconfig -v|ldconfig -r|g' configure.ac
    ./autogen.sh
}

src_configure() {
	econf \
		--prefix=${INSTALL_DIR} \
		$(use_enable libjpeg-browser libjpeg) \
		$(use_enable zrtp libzrtp) \
		|| die
}

src_install() {
	emake DESTDIR=${D} install || die

	echo PATH=/opt/${PN}/bin > ${T}/99${PN}
	echo LDPATH=/opt/${PN}/lib >> ${T}/99${PN}
	echo CONFIG_PROTECT=${INSTALL_DIR}/openmcu-ru/config >> ${T}/99${PN}
        doenvd "${T}"/99${PN}

	newinitd "${FILESDIR}/openmcu-ru-git.initd" openmcu-ru
}

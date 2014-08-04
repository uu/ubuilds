# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit multilib multilib-minimal

DESCRIPTION="Unofficial Telegram Desktop App"
HOMEPAGE="http://tdesktop.com"
TD_32_URI="https://storage.googleapis.com/tlinux32/tsetup32.${PV}.tar.xz"
TD_64_URI="https://storage.googleapis.com/tlinux/tsetup.${PV}.tar.xz"
SRC_URI="
	abi_x86_32? ( ${TD_32_URI} )
	abi_x86_64? ( ${TD_64_URI} )
	"
S=${WORKDIR}/Telegram

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	media-sound/pulseaudio
"

src_install() {
	newbin Telegram telegram
	newbin Updater telegram-updater
}



# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

# NetworkManager likes itself with capital letters
MY_P=${P/networkmanager/NetworkManager}

DESCRIPTION="NetworkManager StrongSwan plugin."
HOMEPAGE="http://www.strongswan.org/"
SRC_URI="http://download.strongswan.org/NetworkManager/${MY_P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-crypt/libsecret
	>=net-misc/networkmanager-1.1.0
	>=net-vpn/strongswan-5.5.1[networkmanager]
	gnome-base/libgnomeui
	dev-libs/dbus-glib
	x11-libs/gtk+:3
	gnome-base/libgnome-keyring"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
		--disable-more-warnings \
		--disable-static \
		--with-charon="${EPREFIX}/usr/libexec/ipsec/charon-nm"
}

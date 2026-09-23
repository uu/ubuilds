# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Janus WebRTC Server"
HOMEPAGE="https://janus.conf.meetecho.com/"
SRC_URI="https://github.com/meetecho/janus-gateway/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

inherit autotools

LICENSE="GPL-3.0-only"
SLOT="0"
KEYWORDS="amd64"

DEPEND="acct-user/janus
acct-group/janus
dev-libs/jansson
dev-libs/libconfig
net-libs/libnice
net-libs/libmicrohttpd
net-libs/sofia-sip
media-libs/opus
media-libs/libogg
dev-libs/nanomsg
net-libs/libwebsockets[libuv,lejp]
net-libs/nodejs[npm]
net-libs/rabbitmq-c
net-libs/usrsctp
net-libs/libsrtp:2
dev-lang/duktape"
RDEPEND="${DEPEND}"
BDEPEND=""
IUSE="static"
RESTRICT="network-sandbox"

src_prepare() {
	eautoreconf
	eapply_user
}

src_configure(){
	econf --prefix=/usr \
		--sysconfdir=/etc \
		--runstatedir=/run \
		--enable-rest \
		--enable-turn-rest-api \
		--enable-post-processing \
		--enable-json-logger \
		--disable-plugin-lua \
		--enable-plugin-sip \
		--enable-plugin-duktape \
		--disable-mqtt \
		--disable-docs \
		$(use_enable static) \
		--enable-javascript-es-module \
		--enable-all-js-modules \
		--enable-javascript-umd-module \
		--enable-javascript-common-js-module \
		--enable-javascript-iife-module \
		--enable-sample-event-handler \
		--enable-aes-gcm
}

src_install() {
	emake DESTDIR="${D}" install
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
}

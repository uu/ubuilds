# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Scalable Web Platform by Extending NGINX with Lua"
HOMEPAGE="https://openresty.org/"
SRC_URI="https://openresty.org/download/openresty-${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="!www-servers/nginx
dev-libs/libpcre[jit]
>=dev-lang/luajit-2.1.0_beta3_p20220127-r2
virtual/libcrypt"
RDEPEND="${DEPEND}"
BDEPEND=""

_modules_dir="/usr/lib64/nginx/modules"

src_prepare() {
	sed -i.orig -e '/--add-module=$dir/s/module/dynamic-&/' configure
	default
}

src_configure() {
	local _pkgname=nginx

	./configure \
	--prefix=/usr/lib64/$_pkgname \
	--sbin-path=/usr/sbin/$_pkgname \
	--modules-path="$_modules_dir" \
	--conf-path=/etc/$_pkgname/$_pkgname.conf \
	--pid-path=/var/run/$_pkgname/$_pkgname.pid \
	--lock-path=/var/run/$_pkgname/$_pkgname.lock \
	--error-log-path=/var/log/$_pkgname/error.log \
	--http-log-path=/var/log/$_pkgname/access.log \
	\
	--http-client-body-temp-path=/var/tmp/$_pkgname/client_body \
	--http-proxy-temp-path=/var/tmp/$_pkgname/proxy \
	--http-fastcgi-temp-path=/var/tmp/$_pkgname/fastcgi \
	--http-uwsgi-temp-path=/var/tmp/$_pkgname/uwsgi \
	--http-scgi-temp-path=/var/tmp/$_pkgname/scgi \
	--with-perl_modules_path=/usr/lib64/perl5/vendor_perl \
	\
	--user=$_pkgname \
	--group=$_pkgname \
	--with-threads \
	--with-file-aio \
	\
	--with-http_ssl_module \
	--with-http_v2_module \
	--with-http_realip_module \
	--with-http_addition_module \
	--with-http_xslt_module=dynamic \
	--with-http_image_filter_module=dynamic \
	--with-http_geoip_module=dynamic \
	--with-luajit=/usr \
	--with-http_sub_module \
	--with-http_dav_module \
	--with-http_flv_module \
	--with-http_mp4_module \
	--with-http_gunzip_module \
	--with-http_gzip_static_module \
	--with-http_auth_request_module \
	--with-http_random_index_module \
	--with-http_secure_link_module \
	--with-http_degradation_module \
	--with-http_slice_module \
	--with-http_stub_status_module \
	--with-http_perl_module=dynamic \
	--with-mail=dynamic \
	--with-mail_ssl_module \
	--with-stream=dynamic \
	--with-stream_ssl_module \
	--with-stream_realip_module \
	--with-stream_geoip_module=dynamic \
	--with-stream_ssl_preread_module \
	--with-pcre-jit \

}


src_install() {
	keepdir $_modules_dir
	keepdir /var/log/nginx
	keepdir /etc/nginx
	keepdir /var/run/nginx
	cp "${FILESDIR}"/nginx.conf-r2 "${ED}"/etc/nginx/nginx.conf || die

	newinitd "${FILESDIR}"/nginx.initd-r4 nginx
	newconfd "${FILESDIR}"/nginx.confd nginx

	default
}

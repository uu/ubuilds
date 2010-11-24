# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Pinba PHP extension"
HOMEPAGE="http://pinba.org"
SRC_URI="http://pinba.org/files/pinba_extension-${PV}.tgz"

PHP_EXT_NAME="pinba"
PHP_EXT_INI="no"
PHP_EXT_ZENDEXT="no"
inherit autotools eutils php-ext-source-r2

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DISTDIR="/usr/portage/distfiles/"
DEPEND="dev-lang/php
	dev-util/re2c
	dev-php/pinba"
RDEPEND="${DEPEND}"


#rc_configure() {
#cd pinba-${PV}	
#phpize
	#eautoconf
	#eaclocal
	#utoreconf
#
src_prepare() {
	mv pinba-${PV} ${P}
	php-ext-source-r2_src_prepare
#	phpize
#	cd pinba-${PV}	
#	econf --with-pinba=/usr
#	rm aclocal.m4
#	eautoreconf
#	elibtoolize


}
#need_php_by_category
src_install() {
	cd pinba-${PV}	
	php-ext-source-r2_src_install
	dodir "${PHP_EXT_SHARED_DIR}"
	insinto "${PHP_EXT_SHARED_DIR}"
	doins pinba.php

	#einstall
	#php-lib-r1_src_install ./ 
}

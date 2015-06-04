# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-memcached/pecl-memcached-2.1.0-r2.ebuild,v 1.4 2013/08/13 21:55:59 ago Exp $

EAPI="5"
PHP_EXT_NAME="memcached"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README"

USE_PHP="php7-0 php5-6 php5-5 php5-3 php5-4"

inherit php-ext-pecl-r2 git-2

KEYWORDS="amd64 x86"
EGIT_REPO_URI="https://github.com/php-memcached-dev/php-memcached.git"
DESCRIPTION="PHP extension for interfacing with memcached via libmemcached library"
LICENSE="PHP-3"
SLOT="0"
IUSE="+session igbinary json sasl"

#if use php_targets_php7-0 ; then
#EGIT_BRANCH="php7"
#else
EGIT_BRANCH="master"
#fi

SRC_URI=""

DEPEND="|| ( >=dev-libs/libmemcached-1.0.14 >=dev-libs/libmemcached-1.0[sasl?] )
		sys-libs/zlib
		dev-lang/php[session?,json?]"
RDEPEND="${DEPEND}"

src_configure() {
	my_conf="--enable-memcached
		$(use_enable session memcached-session)
		$(use_enable sasl memcached-sasl)
		$(use_enable json memcached-json)
		$(use_enable igbinary memcached-igbinary)"

	php-ext-source-r2_src_configure
}

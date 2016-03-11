# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-memcached/pecl-memcached-2.1.0-r2.ebuild,v 1.4 2013/08/13 21:55:59 ago Exp $

EAPI="5"
PHP_EXT_NAME="mysql"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README"

USE_PHP="php7-0"

inherit php-ext-pecl-r2 git-2

KEYWORDS="-*"
EGIT_REPO_URI="https://github.com/php/pecl-database-mysql"
DESCRIPTION="Legacy MySQL extension http://pecl.php.net/database/mysql"
LICENSE="PHP-3"
SLOT="0"
IUSE=""


SRC_URI=""

DEPEND=""
RDEPEND="${DEPEND}"

#src_configure() {
#	my_conf="--enable-memcached
#		$(use_enable session memcached-session)
#		$(use_enable sasl memcached-sasl)
#		$(use_enable json memcached-json)
#		$(use_enable igbinary memcached-igbinary)"
#
#	php-ext-source-r2_src_configure
#}

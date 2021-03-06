# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PHP_EXT_NAME="zookeeper"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php7-0 php7-1"

inherit php-ext-pecl-r3

DESCRIPTION="php extension for connections to zookeeper server"

LICENSE="PHP 3.01"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-lang/php[curl,hash,ssl] ( || ( dev-libs/libzookeeper
sys-cluster/zookeeper ) )"
RDEPEND="${DEPEND}"
IUSE=""

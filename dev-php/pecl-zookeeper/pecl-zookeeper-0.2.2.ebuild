# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PHP_EXT_NAME="zookeeper"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-5 php5-3 php5-4 php5-6"

inherit php-ext-pecl-r2 confutils eutils

DESCRIPTION="php extension for connections to zookeeper server"

LICENSE="PHP 3.01"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-lang/php[curl,hash,ssl] ( || ( dev-libs/libzookeeper
sys-cluster/zookeeper ) )"
RDEPEND="${DEPEND}"
IUSE=""
#my_conf="--with-libzookeeper-dir=/home/www/utinet/zookeeper-devel/src/c/"
#need_php_by_category

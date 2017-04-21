# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="weakref"
PHP_EXT_PECL_PKG="Weakref"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README.md"

USE_PHP="php7-1 php7-0 php5-6 php5-5"

inherit php-ext-pecl-r3

KEYWORDS="amd64 ppc ppc64 x86"

DESCRIPTION="A weak reference provides a gateway to an object without preventing that object from being collected by the garbage collector (GC)."
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""

RDEPEND="${PHPUSEDEPEND}"
DEPEND="${RDEPEND}"

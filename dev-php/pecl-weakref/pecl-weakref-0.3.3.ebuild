# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PHP_EXT_NAME="weakref"
PHP_EXT_PECL_PKG="Weakref"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README"

USE_PHP="php7-1 php7-0 php5-6 php5-5"

inherit php-ext-pecl-r2

KEYWORDS="amd64 ppc ppc64 x86"

DESCRIPTION="A weak reference provides a gateway to an object without preventing that object from being collected by the garbage collector (GC)."
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""

for target in ${USE_PHP}; do
	slot=${target/php}
	slot=${slot/-/.}
	PHPUSEDEPEND="${PHPUSEDEPEND}"
	#php_targets_${target}? ( dev-lang/php:${slot}[unicode] )"
done

RDEPEND="${PHPUSEDEPEND}"
DEPEND="${RDEPEND}"

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PHP_EXT_NAME="timezonedb"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php8-2 php8-3 php8-4"

inherit php-ext-pecl-r3

DESCRIPTION="Timezone Database to be used with PHP's date and time functions"
LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc x86"
IUSE=""
PHP_EXT_ECONF_ARGS=""

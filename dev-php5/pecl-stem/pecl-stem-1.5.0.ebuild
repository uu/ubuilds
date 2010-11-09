# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

#DESCRIPTION=""
#HOMEPAGE=""
#SRC_URI=""

#LICENSE=""
#SLOT="0"
#KEYWORDS="~x86"
#IUSE=""

#DEPEND=""
#RDEPEND="${DEPEND}"

PHP_EXT_NAME="stem"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

inherit php-ext-pecl-r1

DESCRIPTION="a PHP extension that provides word stemming"

LICENSE="PHP 3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="examples"

DEPEND="dev-lang/php[curl,hash,ssl]"
RDEPEND="${DEPEND}"

need_php_by_category

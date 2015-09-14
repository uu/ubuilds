# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-memcached/pecl-memcached-2.1.0-r2.ebuild,v 1.4 2013/08/13 21:55:59 ago Exp $

EAPI="5"
PHP_EXT_NAME="mailparse"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README"

USE_PHP="php7-0"

inherit php-ext-pecl-r2 git-2

KEYWORDS="amd64 x86"
EGIT_REPO_URI="https://github.com/Sean-Der/pecl-mail-mailparse.git"
DESCRIPTION="A PHP extension for parsing and working with RFC822 and RFC2045 (MIME) compliant messages"
LICENSE="PHP-2.02"
SLOT="0"
IUSE=""

EGIT_BRANCH="php7"

SRC_URI=""

for target in ${USE_PHP}; do
	slot=${target/php}
	slot=${slot/-/.}
	PHPUSEDEPEND="${PHPUSEDEPEND}
	php_targets_${target}? ( dev-lang/php:${slot}[unicode] )"
done

RDEPEND="${PHPUSEDEPEND}"
DEPEND="${RDEPEND}
	dev-util/re2c"
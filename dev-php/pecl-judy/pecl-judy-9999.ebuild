# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-memcached/pecl-memcached-2.1.0-r2.ebuild,v 1.4 2013/08/13 21:55:59 ago Exp $

EAPI="6"
PHP_EXT_NAME="judy"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README"
PHP_EXT_PECL_PKG="pecl-judy"

USE_PHP="php7-0 php7-1"

inherit php-ext-pecl-r3 git-r3

KEYWORDS="amd64 x86"
EGIT_REPO_URI="https://github.com/tony2001/php-judy.git"
DESCRIPTION="PHP Extension for libJudy http://pecl.php.net/package/Judy"
LICENSE="PHP-3"
SLOT="0"
IUSE=""

EGIT_BRANCH="php7"

SRC_URI=""

DEPEND="dev-libs/judy
		sys-libs/zlib
		dev-lang/php"
RDEPEND="${DEPEND}"

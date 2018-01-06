# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PHP_EXT_NAME="redis"
PHP_EXT_INI="yes"
PHPSAPILIST="apache2 cgi cli fpm"
USE_PHP="php7-0"
inherit php-ext-source-r2 git-2 autotools

DESCRIPTION="A PHP extension for Redis."
HOMEPAGE="https://github.com/phpredis/phpredis"
EGIT_REPO_URI="https://github.com/phpredis/phpredis.git"
EGIT_BRANCH="php7"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="threads session"

DEPEND="dev-lang/php[threads=,session=]"
RDEPEND="${DEPEND}"

#src_prepare() {
#	epatch ${FILESDIR}/sessions.patch
#}

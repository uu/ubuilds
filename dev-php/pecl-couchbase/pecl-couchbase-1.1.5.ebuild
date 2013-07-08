# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-apc/pecl-apc-3.1.13.ebuild,v 1.2 2013/04/09 08:49:14 olemarkus Exp $

EAPI=5

PHP_EXT_NAME="couchbase"
PHP_EXT_PECL_PKG="couchbase"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README.md LICENSE CREDITS CONTRIBUTING.md"


USE_PHP="php5-5 php5-3 php5-4"

inherit php-ext-pecl-r2 eutils

KEYWORDS="amd64 ~mips ~ppc ~ppc64 x86"

DESCRIPTION="The PHP client library provides fast access to documents in Couchbase Server 2.0. "
LICENSE="PHP-3.01"
SLOT="0"

DEPEND="dev-libs/libcouchbase"
RDEPEND="${DEPEND}"

IUSE=""

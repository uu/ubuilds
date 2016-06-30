# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_PHP="php7-0 php5-6 php5-5"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Resource and persistent handles factory"
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

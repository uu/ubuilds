# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PHP_EXT_NAME="spx"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( README.md )

USE_PHP="php8-1 php8-2 php8-3"

inherit php-ext-source-r3 git-r3

KEYWORDS="amd64 x86"

DESCRIPTION="A simple and straight-to-the-point PHP profiling extension"
HOMEPAGE="https://github.com/NoiseByNorthwest/php-spx"
SRC_URI=""
EGIT_REPO_URI="https://github.com/NoiseByNorthwest/php-spx.git"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="dev-lang/php[-threads]"
RDEPEND=""

src_unpack() {
	git-r3_src_unpack

	for slot in $(php_get_slots); do
    	cp -r "${S}" "${WORKDIR}/${slot}"
	done
}


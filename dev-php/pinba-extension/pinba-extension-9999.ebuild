# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PHP_EXT_NAME="pinba"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( NEWS README CREDITS )

USE_PHP="php5-6 php7-0 php7-1"

inherit php-ext-source-r3 git-r3

KEYWORDS="amd64 x86"

DESCRIPTION="Pinba is a realtime monitoring/statistics server for PHP using 
MySQL as a read-only interface."
HOMEPAGE="http://pinba.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/tony2001/pinba_extension.git"

LICENSE="PHP-3"
SLOT="0"
IUSE="threads"

DEPEND="dev-lang/php[threads=]
        dev-libs/protobuf"
RDEPEND=""

src_unpack() {
  git-r3_src_unpack

  for slot in $(php_get_slots); do
    cp -r "${S}" "${WORKDIR}/${slot}"
  done
}

src_install() {
  php-ext-source-r3_src_install
  php-ext-source-r3_addtoinifiles "pinba.enabled" "0"
  php-ext-source-r3_addtoinifiles "pinba.server" "127.0.0.1:30002"
}


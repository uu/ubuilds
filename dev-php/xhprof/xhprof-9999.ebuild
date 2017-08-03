# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/xhprof/xhprof-0.9.2.ebuild,v 1.2 2011/03/27 04:50:11 mr_bones_ Exp $

EAPI=6

PHP_EXT_NAME="xhprof"
PHP_EXT_INI="yes"
PHP_EXT_S="${WORKDIR}/${P}/extension"
PHPSAPILIST="apache2 cgi fpm cli"
DOCS=( CHANGELOG )

USE_PHP="php7-0 php7-1"
PHP_EXT_ECONF_ARGS=( --enable-xhprof=shared )

inherit php-ext-source-r3 git-r3

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RESTRICT="test"

HOMEPAGE="https://github.com/facebook/xhprof.git"
DESCRIPTION="A Hierarchical Profiler for PHP"
SRC_URI=""
EGIT_REPO_URI="https://github.com/RustJason/xhprof.git"
EGIT_BRANCH="php7"


DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
  git-r3_src_unpack

  for slot in $(php_get_slots); do
    cp -r "${PHP_EXT_S}" "${WORKDIR}/${slot}"
    cp "${S}/${DOCS}" "${WORKDIR}/${slot}"
  done
}

src_install() {
  php-ext-source-r3_src_install
  php-ext-source-r3_addtoinifiles "xhprof.output_dir" "/tmp"
  cd ${S}
  insinto "${PHP_EXT_SHARED_DIR}"
  doins -r xhprof_html
  insinto "${PHP_EXT_SHARED_DIR}"
  doins -r xhprof_lib
}

pkg_postinst() {
  einfo "The xhprof_html/ and the xhprof_lib/ directory shipped with this"
  einfo "release were installed into ${PHP_EXT_SHARED_DIR}"
}


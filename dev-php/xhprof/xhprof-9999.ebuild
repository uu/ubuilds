# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/xhprof/xhprof-0.9.2.ebuild,v 1.2 2011/03/27 04:50:11 mr_bones_ Exp $

EAPI="5"

PHP_EXT_NAME="xhprof"
PHP_EXT_INI="yes"
PHP_EXT_S="${WORKDIR}/${P}/extension"
PHPSAPILIST="apache2 cgi fpm cli"

USE_PHP="php5-3 php5-4 php5-5 php5-6 php7-0"
inherit php-ext-source-r2 confutils git-2

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="test"

HOMEPAGE="https://github.com/facebook/xhprof.git"
DESCRIPTION="A Hierarchical Profiler for PHP"
SRC_URI=""
EGIT_PROJECT="xhprof"
EGIT_REPO_URI="https://github.com/phacility/xhprof.git"

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	git-2_src_unpack
	local slot orig_s="${PHP_EXT_S}"
	for slot in $(php_get_slots); do
		cp -r "${orig_s}" "${WORKDIR}/${slot}" || die "Failed to copy source ${orig_s} to PHP target directory"
		cd ${WORKDIR}/${slot}
	done
}

src_configure() {
	my_conf="--enable-xhprof=shared"

	php-ext-source-r2_src_configure
}

src_install() {
	php-ext-source-r2_src_install
	cd ${S}
	dodoc CHANGELOG CREDITS README

	php-ext-source-r2_addtoinifiles "xhprof.output_dir" '"/tmp"'

	insinto "${PHP_EXT_SHARED_DIR}"
	doins -r xhprof_html
	insinto "${PHP_EXT_SHARED_DIR}"
	doins -r xhprof_lib
}

pkg_postinst() {
	elog "The xhprof_html/ and the xhprof_lib/ directory shipped with this"
	elog "release were installed into ${PHP_EXT_SHARED_DIR}"
}

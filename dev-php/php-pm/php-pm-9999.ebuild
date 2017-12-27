# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 composer

DESCRIPTION="PPM is a process manager, supercharger and load balancer for modern PHP applications."
HOMEPAGE="https://github.com/php-pm/php-pm"
SRC_URI=""
EGIT_REPO_URI="https://github.com/php-pm/php-pm.git"


LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="dev-lang/php[cgi]
        dev-php/composer"
RDEPEND="${DEPEND}"

src_configure() {
	composer_pkg_setup
}

src_install() {
	ecomposer_install || die
	composer_copy_install_all || die
	composer_install_bins || die
}

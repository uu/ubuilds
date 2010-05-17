# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="*:2.6"
SUPPORT_PYTHON_ABIS="1"

inherit fdo-mime gnome2-utils distutils eutils subversion

ESVN_REPO_URI="http://overlays.gentoo.org/svn/proj/java/projects/java-config-2/trunk/"

DESCRIPTION="Java environment configuration tool"
HOMEPAGE="http://www.gentoo.org/proj/en/java/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=">=dev-java/java-config-wrapper-0.15"
# Tests fail when java-config isn't already installed.
RESTRICT="test"
RESTRICT_PYTHON_ABIS="2.4 2.5"

PYTHON_MODNAME="java_config_2"

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" src/run-test-suite.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	insinto /usr/share/java-config-2/config/
	newins config/jdk-defaults-${ARCH}.conf jdk-defaults.conf || die "arch config not found"
}

pkg_postrm() {
	distutils_pkg_postrm
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postinst() {
	distutils_pkg_postinst
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

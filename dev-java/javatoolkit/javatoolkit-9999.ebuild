# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils subversion multilib

ESVN_REPO_URI="http://overlays.gentoo.org/svn/proj/java/projects/javatoolkit/trunk"

DESCRIPTION="Collection of Gentoo-specific tools for Java"
HOMEPAGE="http://www.gentoo.org/proj/en/java/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

PYTHON_MODNAME="javatoolkit"

src_install() {
	distutils_src_install --install-scripts="/usr/$(get_libdir)/${PN}/bin"
}

pkg_postrm() {
	distutils_python_version
	distutils_pkg_postrm
}

pkg_postinst() {
	distutils_pkg_postinst
}

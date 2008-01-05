# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils subversion

ESVN_REPO_URI="http://overlays.gentoo.org/svn/proj/java/projects/javatoolkit/branches/layout_refactor_branch"

DESCRIPTION="Collection of Gentoo-specific tools for Java"
HOMEPAGE="http://www.gentoo.org/proj/en/java/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

PYTHON_MODNAME="javatoolkit"

pkg_postrm() {
	distutils_python_version
	distutils_pkg_postrm
}

pkg_postinst() {
	distutils_pkg_postinst
}

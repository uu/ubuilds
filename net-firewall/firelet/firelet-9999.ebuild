# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/fabric/fabric-1.4.2-r1.ebuild,v 1.2 2012/05/16 17:51:54 floppym Exp $

EAPI="4"
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.* *-jython *-pypy-*"
DISTUTILS_SRC_TEST="nosetests"

# Requires multiprocessing package from py2.6+
PYTHON_TESTS_RESTRICTED_ABIS="2.5"

inherit distutils eutils vcs-snapshot git-2

DESCRIPTION="Distributed Linux-based firewall management"
HOMEPAGE="http://www.firelet.net"
#SRC_URI="http://github.com/${PN}/${PN}/tarball/${PV} -> ${P}.tar.gz"
SRC_URI=""
EGIT_REPO_URI="git://github.com/FedericoCeratto/firelet.git"


LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="dev-python/bottle dev-python/pygraphviz dev-python/netaddr"
DEPEND="${RDEPEND}
	dev-python/setuptools"

#PYTHON_MODULES="fabfile fabric"

#src_prepare() {
#	use doc &&
#		epatch "${FILESDIR}"/${P}-git_tags_docs.patch
#}

#src_compile() {
#	distutils_src_compile
#
#	if use doc; then
#		emake -C docs html
#	fi
#}
#
src_install() {

	distutils_src_install
	newinitd ${S}/extras/firelet.init.d ${PN}
#
#	if use doc; then
#		dohtml -r docs/_build/html/
#	fi
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P=${P/pootle/Pootle}

DESCRIPTION="PO-based Online Translation / Localization Engine"
HOMEPAGE="http://translate.sourceforge.net/"
SRC_URI="https://github.com/translate/pootle/releases/download/${PV}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"
IUSE=""


DEPEND="dev-python/kid
	dev-python/jtoolkit
	dev-python/psyco"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack(){
	unpack ${A}
	cd "${S}"
	ln -sf pootlesetup.py setup.py
}

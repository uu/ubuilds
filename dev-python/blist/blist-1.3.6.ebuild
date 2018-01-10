# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="A list-like type with better asymptotic performance and similar performance on small lists"
HOMEPAGE="http://stutzbachenterprises.com/blist/"
#SRC_URI="https://pypi.python.org/packages/2f/8d/bee8a59732c169a455627ff1557d0db180f7c352b0274480267ad3e46875/${P}.tar.gz -> ${P}.tar.gz"
#SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test"

CDEPEND=""

RDEPEND="${CDEPEND}"
DEPEND=""

python_test() {
	nosetests tests || die "Tests fail with ${EPYTHON}"
}


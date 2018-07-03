# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="The tool for updating your Suricata rules."
HOMEPAGE="https://github.com/OISF/suricata-update"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}b1.tar.gz"
S="${WORKDIR}/${P}b1"
LICENSE="GPL2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RESTRICT="test" 	#missing in tarball

DEPEND="
	dev-python/pip[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
	"
RDEPEND=""
python_prepare_all() {
	# Required to avoid file collisions at install
	sed \
		-e "/find_packages/s:]:,'tests.*','doc']:g" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}


python_install_all() {
	use doc && local DOC=( doc/. )
	distutils-r1_python_install_all
}

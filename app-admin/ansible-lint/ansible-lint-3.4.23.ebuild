# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Best practices checker for Ansible"
HOMEPAGE="https://github.com/willthames/ansible-lint"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

RESTRICT="test" 	#missing in tarball

DEPEND="
	dev-python/pip[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
	"
RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	app-admin/ansible[${PYTHON_USEDEP}]
"
python_prepare_all() {
	# Required to avoid file collisions at install
	sed \
		-e "/find_packages/s:]:,'tests.*','examples']:g" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}


python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}

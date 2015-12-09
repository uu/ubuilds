# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="A User Interface for the PoWA project"
HOMEPAGE="https://pypi.python.org/pypi/powa-web/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="DALIBO"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND="
dev-python/sqlalchemy
dev-python/psycopg:2
www-servers/tornado
${DEPEND}"

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test.py --verbose
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	newinitd "${FILESDIR}/powa-web.init" powa-web
	newconfd "${FILESDIR}/powa-web.conf" powa-web
	insinto /etc/
	newins powa-web.conf-dist powa-web.conf
}


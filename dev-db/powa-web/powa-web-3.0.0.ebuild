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


#src_compile() {
#    emake -j1 USE_PGXS=1
#}

src_install() {
	distutils_src_install

	newinitd "${FILESDIR}/powa-web.init" powa-web
	newconfd "${FILESDIR}/powa-web.conf" powa-web
	insinto /etc/
	newins powa-web.conf-dist powa-web.conf
#	pg_libdir=$(pg_config --pkglibdir)
#	insinto ${pg_libdir}
#	doins ${MY_P}.so
#
#	pg_shared=$(pg_config --sharedir)
#	insinto ${pg_shared}/extension
#	doins ${MY_P}.control
#	doins ${MY_P}--${PV}.sql
#	
#	dodoc README.md
}

pkg_config() {
	einfo "Add to your postgresql.conf :"
	einfo
	einfo "shared_preload_libraries = 'pg_stat_statements,powa'"
	einfo
	einfo "Enable powa by creating an extension with:"
	einfo
	einfo "your_database=# CREATE EXTENSION pg_stat_statements;"
	einfo "your_database=# CREATE EXTENSION btree_gist;"
	einfo "your_database=# CREATE EXTENSION powa;"
	einfo
}

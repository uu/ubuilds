# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
inherit distutils

DESCRIPTION="Get a detailed, real-time view of your PostgreSQL database and system metrics"
HOMEPAGE="https://pypi.python.org/pypi/pg-view"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
#SRC_URI="https://github.com/prometheus/client_python/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""


RDEPEND="dev-python/psycopg:2"
DEPEND="dev-python/setuptools"

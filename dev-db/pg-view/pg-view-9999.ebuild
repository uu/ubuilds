# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
inherit distutils git-2

DESCRIPTION="Get a detailed, real-time view of your PostgreSQL database and system metrics"
HOMEPAGE="https://pypi.python.org/pypi/pg-view"
EGIT_REPO_URI="git://github.com/zalando/pg_view.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""


RDEPEND="dev-python/psycopg:2"
DEPEND="dev-python/setuptools"

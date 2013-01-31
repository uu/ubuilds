# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
# DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Python client library for AMQP"
HOMEPAGE="http://pika.github.com/"
#SRC_URI="https://github.com/${PN}/${PN}/tarball/v${PV} -> ${P}.tar.gz"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools"

S="${WORKDIR}/${PN}-${PN}-120fdea"

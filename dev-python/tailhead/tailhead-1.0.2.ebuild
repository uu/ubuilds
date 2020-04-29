# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
PYTHON_COMPAT=(python2_7 python3_4 python3_5 python3_6 python3_7)

inherit distutils-r1

DESCRIPTION="head, tail and follow in python"
HOMEPAGE="https://github.com/GreatFruitOmsk/tailhead"
SRC_URI="https://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
PYTHON_COMPAT=(python3_8 python3_9 python3_10)

inherit distutils-r1

DESCRIPTION="head, tail and follow in python"
HOMEPAGE="https://github.com/GreatFruitOmsk/tailhead"
SRC_URI="https://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

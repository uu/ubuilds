# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1

DESCRIPTION="Python interfaces for ADI hardware with IIO drivers"
HOMEPAGE="
	https://pypi.org/project/pyadi-iio/
	https://github.com/analogdevicesinc/pyadi-iio
"
SRC_URI="
	https://github.com/analogdevicesinc/pyadi-iio/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
distutils_enable_tests pytest

S="${WORKDIR}/py${P}"

LICENSE="LIBGLOSS"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/frozenlist-1.1.0[${PYTHON_USEDEP}]
	net-libs/libiio[python]
	dev-python/numpy
"
BDEPEND=""


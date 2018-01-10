# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Python STOMP client, supporting versions 1.0, 1.1 and 1.2 of the protocol"
HOMEPAGE="https://github.com/jasonrbriggs/stomp.py"
SRC_URI="https://github.com/jasonrbriggs/stomp.py/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test"

CDEPEND=""

RDEPEND="${CDEPEND}"
DEPEND=""

python_test() {
	nosetests tests || die "Tests fail with ${EPYTHON}"
}


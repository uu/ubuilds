# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=(python2_7 python3_7 python3_8 python3_9)

inherit distutils-r1

DESCRIPTION="A cluster solution for Janus WebRTC server, by API proxy approach"
HOMEPAGE="https://github.com/OpenSight/janus-cloud"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""
#PATCHES="${FILESDIR}/*patch"

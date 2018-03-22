# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=(python2_7 python3_4 python3_5 python3_6)

inherit distutils-r1

DESCRIPTION="Perform a DNS-01 challenge using TXT record in a PowerDNS"
HOMEPAGE="https://github.com/robin-thoni/certbot-pdns"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""
PATCHES="${FILESDIR}/*patch"

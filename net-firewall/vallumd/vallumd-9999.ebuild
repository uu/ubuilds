# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [ "${PV}" = 9999 ]; then
	inherit git-r3
	EGIT_REPO_URI="https://codeberg.org/stintel/vallumd.git"
else
	KEYWORDS="~amd64 ~mips ~x86"
	SRC_URI="https://codeberg.org/stintel/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}"
fi

DESCRIPTION="Centralize or distribute IP blacklists"
HOMEPAGE="https://codeberg.org/stintel/vallumd"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="app-misc/mosquitto
		net-firewall/ipset"
RDEPEND="${DEPEND}"

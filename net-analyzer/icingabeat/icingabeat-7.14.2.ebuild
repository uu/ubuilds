# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Elastic Beat fetching events & status from Icinga 2"
HOMEPAGE="https://github.com/Icinga/icingabeat"
SRC_URI="https://github.com/Icinga/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	export GOPATH=${WORKDIR}
	ebegin "getting code"
	go get -d || die 'could not get'
	eend $?
	default
}

src_install() {
	newbin ${P} ${PN}
	dodir /etc/${PN}
	insinto /etc/${PN}
	doins ${PN}.yml ${PN}.full.yml
}

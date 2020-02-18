# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit git-r3 eutils
DESCRIPTION="View ip accesses to your server on a world map (using geoip and d3.js)"
HOMEPAGE="https://github.com/tomerdmnt/geoipmap"
SRC_URI=""
EGIT_REPO_URI="https://github.com/tomerdmnt/geoipmap.git"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="dev-lang/go"
RDEPEND="${DEPEND}"

src_compile(){
	export GOPATH=${WORKDIR}

	ebegin "getting code"
	go get -d || die 'could not get'
	eend $?
	ebegin "building code"
	go build -o ${PN} || die 'could not build'
	eend $?
}

src_install() {
	insinto /usr/bin
	dobin ${PN}
}

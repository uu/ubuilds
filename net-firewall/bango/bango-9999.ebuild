# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
inherit git-r3
DESCRIPTION="Distributed banning system for fail2ban"
HOMEPAGE="https://github.com/uu/bango"
SRC_URI=""
EGIT_REPO_URI="https://github.com/uu/bango.git"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE=""

DEPEND="net-analyzer/fail2ban
		dev-lang/go"
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
	insinto /etc
	doins ${PN}.ini
	newinitd ${FILESDIR}/init ${PN}
	insinto /etc/fail2ban/action.d/
	doins actions/${PN}.conf
}

# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
inherit git-r3 eutils autotools
DESCRIPTION="An experiment to cut logs in preparation for processing elsewhere."
HOMEPAGE="https://github.com/martymac/fpart"
SRC_URI=""
EGIT_REPO_URI="https://github.com/martymac/fpart.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="${DEPEND}"

src_compile(){
	eautoreconf
	eautoconf
	./configure --prefix=/ --disable-debug
	emake
}
#	export GOPATH=${WORKDIR}
#
#	ebegin "getting code"
#	go get -d || die 'could not get'
#	eend $?
#	ebegin "building code"
#	go build -o ${PN} || die 'could not build'
#	eend $?
#}

#src_install() {
#	insinto /usr/bin
#	dobin ${PN}
#	newinitd ${FILESDIR}/init ${PN}
#}

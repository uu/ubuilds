# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit git-r3 eutils
DESCRIPTION="An experiment to cut logs in preparation for processing elsewhere."
HOMEPAGE="https://github.com/elastic/logstash-forwarder"
SRC_URI=""
EGIT_REPO_URI="https://github.com/elasticsearch/logstash-forwarder.git"

LICENSE="Apache-2"
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
	newinitd ${FILESDIR}/init ${PN}
}

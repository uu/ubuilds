# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GIT_COMMIT="a161e02af5b9bf25e913a4d073e7bb3dc30aa651"
EGO_PN="github.com/grafana/loki"

inherit golang-vcs-snapshot systemd

DESCRIPTION="Gathering logs and sending them to Loki"
HOMEPAGE="https://github.com/grafana/loki"
SRC_URI="https://${EGO_PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="pie"

QA_PRESTRIPPED="usr/bin/promtail"
G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	export GOPATH="${G}"
	local mygoargs=(
		-v -work -x
		"-buildmode=$(usex pie pie default)"
		-asmflags "-trimpath=${S}"
		-gcflags "-trimpath=${S}"
		-ldflags "-s -w"
	)
	cd ./cmd/promtail
	go build "${mygoargs[@]}" || die
}

src_install() {
	dobin cmd/promtail/promtail

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir /var/log/${PN}
}

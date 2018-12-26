# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/wrouesnel/${PN}"

inherit golang-vcs-snapshot systemd user

DESCRIPTION="PostgreSQL stats exporter for Prometheus"
HOMEPAGE="https://github.com/wrouesnel/postgres_exporter"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="pie"

DOCS=( README.md )
QA_PRESTRIPPED="usr/bin/postgres_exporter"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	enewgroup postgres_exporter
	enewuser postgres_exporter -1 -1 -1 postgres_exporter
}

src_compile() {
	export GOPATH="${G}"
	local mygoargs=(
		-v -work -x
		"-buildmode=$(usex pie pie default)"
		-asmflags "-trimpath=${S}"
		-gcflags "-trimpath=${S}"
		-ldflags "-s -w -X main.Version=${PV}"
	)
	go build "${mygoargs[@]}" ./cmd/postgres_exporter || die
}

src_install() {
	dobin postgres_exporter
	einstalldocs

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	diropts -o postgres_exporter -g postgres_exporter -m 0750
	keepdir /var/log/postgres_exporter
}

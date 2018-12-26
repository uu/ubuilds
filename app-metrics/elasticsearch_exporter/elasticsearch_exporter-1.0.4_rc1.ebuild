# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GIT_COMMIT="68340fda9c" # Change this when you update the ebuild
EGO_PN="github.com/justwatchcom/${PN}"

inherit golang-vcs-snapshot systemd user

DESCRIPTION="Elasticsearch stats exporter for Prometheus"
HOMEPAGE="https://github.com/justwatchcom/elasticsearch_exporter"
SRC_URI="https://${EGO_PN}/archive/v${PV/_/}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples pie"

DOCS=( CHANGELOG README.md )
QA_PRESTRIPPED="usr/bin/elasticsearch_exporter"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	enewgroup elasticsearch_exporter
	enewuser elasticsearch_exporter -1 -1 -1 elasticsearch_exporter
}

src_compile() {
	export GOPATH="${G}"
	local PROMU="${EGO_PN}/vendor/github.com/prometheus/common/version"
	local myldflags=( -s -w
		-X "${PROMU}.Version=${PV}"
		-X "${PROMU}.Revision=${GIT_COMMIT}"
		-X "${PROMU}.Branch=non-git"
		-X "${PROMU}.BuildUser=$(id -un)@$(hostname -f)"
		-X "${PROMU}.BuildDate=$(date -u '+%Y%m%d-%I:%M:%S')"
	)
	local mygoargs=(
		-v -work -x
		"-buildmode=$(usex pie pie default)"
		"-asmflags=all=-trimpath=${S}"
		"-gcflags=all=-trimpath=${S}"
		-ldflags "${myldflags[*]}"
	)
	go build "${mygoargs[@]}" || die
}

src_test() {
	go test -v -short ./... || die
}

src_install() {
	dobin elasticsearch_exporter
	einstalldocs

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	if use examples; then
		docinto examples
		dodoc -r example/*
		docompress -x "/usr/share/doc/${PF}/examples"
	fi

	diropts -o elasticsearch_exporter -g elasticsearch_exporter -m 0750
	keepdir /var/log/elasticsearch_exporter
}

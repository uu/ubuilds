# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GIT_COMMIT="79b6110" # Change this when you update the ebuild
EGO_PN="github.com/justwatchcom/${PN}"

inherit golang-vcs-snapshot systemd user

DESCRIPTION="Flexible SQL Exporter for Prometheus"
HOMEPAGE="https://github.com/justwatchcom/sql_exporter"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples pie"

DOCS=( README.md )
QA_PRESTRIPPED="usr/bin/sql_exporter"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	enewgroup sql_exporter
	enewuser sql_exporter -1 -1 -1 sql_exporter
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
		-asmflags "-trimpath=${S}"
		-gcflags "-trimpath=${S}"
		-ldflags "${myldflags[*]}"
	)
	go build "${mygoargs[@]}" || die
}

src_test() {
	go test -v -short -race ./... || die
}

src_install() {
	dobin sql_exporter
	einstalldocs

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	insinto /etc/sql_exporter
	newins config.yml.dist config.yml.example

	if use examples; then
		docinto examples
		dodoc -r example/*
		docompress -x "/usr/share/doc/${PF}/examples"
	fi

	diropts -o sql_exporter -g sql_exporter -m 0750
	keepdir /var/log/sql_exporter
}

pkg_postinst() {
	if [ ! -e "${EROOT%/}"/etc/sql_exporter/config.yml ]; then
		elog "No config.yml found, copying the example over"
		cp "${EROOT%/}"/etc/sql_exporter/config.yml{.example,} || die
	else
		elog "config.yml found, please check example file for possible changes"
	fi
}

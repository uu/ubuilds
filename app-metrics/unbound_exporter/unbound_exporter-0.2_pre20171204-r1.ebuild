# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GIT_COMMIT="4f36729f553665a4268b5c265448977276a95096"
EGO_PN="github.com/kumina/${PN}"
EGO_VENDOR=(
	"github.com/beorn7/perks 3a771d9"
	"github.com/golang/protobuf b4deda0"
	"github.com/matttproud/golang_protobuf_extensions c12348c"
	"github.com/prometheus/client_golang 82f5ff1"
	"github.com/prometheus/client_model 99fa1f4"
	"github.com/prometheus/common d811d2e"
	"github.com/prometheus/procfs 8b1c2da"
	"github.com/Sirupsen/logrus 778f2e7"
)

inherit golang-vcs-snapshot systemd user

DESCRIPTION="A Prometheus exporter for Unbound"
HOMEPAGE="https://github.com/kumina/unbound_exporter"
SRC_URI="https://${EGO_PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="pie"

DOCS=( README.md )
QA_PRESTRIPPED="usr/bin/unbound_exporter"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	enewgroup unbound_exporter
	enewuser unbound_exporter -1 -1 -1 unbound_exporter
}

src_compile() {
	export GOPATH="${G}"
	local mygoargs=(
		-v -work -x
		"-buildmode=$(usex pie pie default)"
		-asmflags "-trimpath=${S}"
		-gcflags "-trimpath=${S}"
		-ldflags "-s -w"
	)
	go build "${mygoargs[@]}" || die
}

src_install() {
	dobin unbound_exporter
	einstalldocs

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	diropts -m 0750 -o unbound_exporter -g unbound_exporter
	keepdir /var/log/unbound_exporter
}

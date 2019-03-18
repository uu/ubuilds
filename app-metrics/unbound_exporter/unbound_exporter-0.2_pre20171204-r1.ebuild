# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GIT_COMMIT="b7e842d893d29200a5108eab717f5ab01d783c0c"
EGO_PN="github.com/kumina/${PN}"
EGO_VENDOR=(
	"github.com/beorn7/perks 3a771d9"
	"github.com/golang/protobuf b4deda0"
	"github.com/matttproud/golang_protobuf_extensions c12348c"
	"github.com/prometheus/client_golang 82f5ff1"
	"github.com/prometheus/client_model 99fa1f4"
	"github.com/prometheus/common d811d2e"
	"github.com/prometheus/procfs 8b1c2da"
	"golang.org/x/crypto a1f597ede03a7bef967a422b5b3a5bd08805a01e github.com/golang/crypto"
	"golang.org/x/sys a2f829d7f35f2ed1c3520c553a6226495455cae0 github.com/golang/sys"
	"github.com/sirupsen/logrus dae0fa8"
	"gopkg.in/alecthomas/kingpin.v2 7613e5d github.com/alecthomas/kingpin"
	"github.com/alecthomas/template a0175ee"
	"github.com/alecthomas/units 2efee85"

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

	keepdir /var/log/unbound_exporter
}

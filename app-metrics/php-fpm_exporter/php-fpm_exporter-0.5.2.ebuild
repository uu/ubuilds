# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Change this when you update the ebuild:
GIT_COMMIT="4dd180146368fd4a233bf24701b483e7e1f64b6c"
EGO_PN="github.com/hipages/${PN}"
# Note: Keep EGO_VENDOR in sync with Gopkg.lock
# Deps that are not needed:
# github.com/inconshreveable/mousetrap 76626ae
# github.com/pmezard/go-difflib 792786c
EGO_VENDOR=(
	"github.com/beorn7/perks 4c0e845"
	"github.com/davecgh/go-spew 8991bc2"
	"github.com/fsnotify/fsnotify c282820"
	"github.com/golang/protobuf 9255415"
	"github.com/gosuri/uitable 36ee7e9"
	"github.com/hashicorp/hcl 23c074d"
	"github.com/magiconair/properties c3beff4"
	"github.com/mattn/go-runewidth 9e777a8"
	"github.com/matttproud/golang_protobuf_extensions 3247c84"
	"github.com/mitchellh/go-homedir b8bc1bf"
	"github.com/mitchellh/mapstructure 00c29f5"
	"github.com/pelletier/go-toml acdc450"
	"github.com/prometheus/client_golang c5b7fcc"
	"github.com/prometheus/client_model 99fa1f4"
	"github.com/prometheus/common 89604d1"
	"github.com/prometheus/procfs 75f2d61"
	"github.com/sirupsen/logrus 8c0189d"
	"github.com/speps/go-hashids d1d57a8"
	"github.com/spf13/afero bb8f192"
	"github.com/spf13/cast 8965335"
	"github.com/spf13/cobra 7b2c5ac"
	"github.com/spf13/jwalterweatherman 7c0cea3"
	"github.com/spf13/pflag e57e3ee"
	"github.com/spf13/viper 25b30aa"
	"github.com/stretchr/testify 69483b4"
	"github.com/tomasen/fcgi_client d32b716"
	"golang.org/x/crypto 8c65384 github.com/golang/crypto"
	"golang.org/x/sys f6cff07 github.com/golang/sys"
	"golang.org/x/text f21a4df github.com/golang/text"
	"gopkg.in/yaml.v2 7f97868 github.com/go-yaml/yaml"
)

inherit golang-vcs-snapshot systemd user

DESCRIPTION="A Prometheus exporter that connects directly to PHP-FPM"
HOMEPAGE="https://github.com/hipages/php-fpm_exporter"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="pie"

DOCS=( README.md )
QA_PRESTRIPPED="usr/bin/php-fpm_exporter"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	enewgroup php-fpm_exporter
	enewuser php-fpm_exporter -1 -1 -1 php-fpm_exporter
}

src_compile() {
	export GOPATH="${G}"
	local myldflags=( -s -w
		-X "main.version=${PV}"
		-X "main.commit=${GIT_COMMIT}"
		-X "main.date=$(date -u '+%Y-%m-%dT%TZ')"
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
	go test -v ./... || die
}

src_install() {
	dobin php-fpm_exporter
	einstalldocs

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	diropts -o php-fpm_exporter -g php-fpm_exporter -m 0750
	keepdir /var/log/php-fpm_exporter
}

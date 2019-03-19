# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Change this when you update the ebuild:
GIT_COMMIT="fba04f828621ece229347d5ec8a6ec529b9bfbe3"
EGO_PN="github.com/hipages/${PN}"
# Note: Keep EGO_VENDOR in sync with Gopkg.lock
# Deps that are not needed:
# github.com/inconshreveable/mousetrap 76626ae
# github.com/pmezard/go-difflib 792786c
EGO_VENDOR=(
	"github.com/beorn7/perks 3a771d9"
	"github.com/davecgh/go-spew d8f796a"
	"github.com/fsnotify/fsnotify 1485a34"
	"github.com/golang/protobuf d3c38a4"
	"github.com/gosuri/uitable 36ee7e9"
	"github.com/hashicorp/hcl 65a6292"
	"github.com/magiconair/properties 7757cc9"
	"github.com/mattn/go-runewidth 703b5e6"
	"github.com/matttproud/golang_protobuf_extensions c182aff"
	"github.com/mitchellh/go-homedir af06845"
	"github.com/mitchellh/mapstructure 3536a92"
	"github.com/pelletier/go-toml 690ec00"
	"github.com/prometheus/client_golang fa4aa90"
	"github.com/prometheus/client_model fd36f42"
	"github.com/prometheus/common 8b74803"
	"github.com/prometheus/procfs e56f2e2"
	"github.com/sirupsen/logrus dae0fa8"
	"github.com/speps/go-hashids 6ba254b"
	"github.com/spf13/afero f4711e4"
	"github.com/spf13/cast 8c9545a"
	"github.com/spf13/cobra ba1052d"
	"github.com/spf13/jwalterweatherman 94f6ae3"
	"github.com/spf13/pflag 24fa697"
	"github.com/spf13/viper 9e56dac"
	"github.com/stretchr/testify 34c6fa2"
	"github.com/tomasen/fcgi_client 2bb3d81"
	"golang.org/x/crypto a1f597e github.com/golang/crypto"
	"golang.org/x/sys 6c81ef8 github.com/golang/sys"
	"golang.org/x/text 5d731a3 github.com/golang/text"
	"gopkg.in/yaml.v2 51d6538 github.com/go-yaml/yaml"
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

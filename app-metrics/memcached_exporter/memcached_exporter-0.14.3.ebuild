# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module
EGO_SUM=(
	"github.com/alecthomas/kingpin/v2 v2.4.0"
	"github.com/alecthomas/kingpin/v2 v2.4.0/go.mod"
	"github.com/alecthomas/units v0.0.0-20211218093645-b94a6e3cc137"
	"github.com/alecthomas/units v0.0.0-20211218093645-b94a6e3cc137/go.mod"
	"github.com/beorn7/perks v1.0.1"
	"github.com/beorn7/perks v1.0.1/go.mod"
	"github.com/cespare/xxhash/v2 v2.2.0"
	"github.com/cespare/xxhash/v2 v2.2.0/go.mod"
	"github.com/coreos/go-systemd/v22 v22.5.0"
	"github.com/coreos/go-systemd/v22 v22.5.0/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/go-kit/log v0.2.1"
	"github.com/go-kit/log v0.2.1/go.mod"
	"github.com/go-logfmt/logfmt v0.6.0"
	"github.com/go-logfmt/logfmt v0.6.0/go.mod"
	"github.com/godbus/dbus/v5 v5.0.4/go.mod"
	"github.com/golang/protobuf v1.3.1/go.mod"
	"github.com/golang/protobuf v1.5.0/go.mod"
	"github.com/golang/protobuf v1.5.3"
	"github.com/golang/protobuf v1.5.3/go.mod"
	"github.com/google/go-cmp v0.5.5/go.mod"
	"github.com/google/go-cmp v0.6.0"
	"github.com/google/go-cmp v0.6.0/go.mod"
	"github.com/grobie/gomemcache v0.0.0-20230213081705-239240bbc445"
	"github.com/grobie/gomemcache v0.0.0-20230213081705-239240bbc445/go.mod"
	"github.com/jpillora/backoff v1.0.0"
	"github.com/jpillora/backoff v1.0.0/go.mod"
	"github.com/kr/pretty v0.3.1"
	"github.com/kr/pretty v0.3.1/go.mod"
	"github.com/kr/text v0.2.0"
	"github.com/kr/text v0.2.0/go.mod"
	"github.com/mwitkow/go-conntrack v0.0.0-20190716064945-2f068394615f"
	"github.com/mwitkow/go-conntrack v0.0.0-20190716064945-2f068394615f/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/prometheus/client_golang v1.19.0"
	"github.com/prometheus/client_golang v1.19.0/go.mod"
	"github.com/prometheus/client_model v0.6.0"
	"github.com/prometheus/client_model v0.6.0/go.mod"
	"github.com/prometheus/common v0.51.0"
	"github.com/prometheus/common v0.51.0/go.mod"
	"github.com/prometheus/exporter-toolkit v0.11.0"
	"github.com/prometheus/exporter-toolkit v0.11.0/go.mod"
	"github.com/prometheus/procfs v0.12.0"
	"github.com/prometheus/procfs v0.12.0/go.mod"
	"github.com/rogpeppe/go-internal v1.10.0"
	"github.com/rogpeppe/go-internal v1.10.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.4.0/go.mod"
	"github.com/stretchr/testify v1.8.2"
	"github.com/stretchr/testify v1.8.2/go.mod"
	"github.com/xhit/go-str2duration/v2 v2.1.0"
	"github.com/xhit/go-str2duration/v2 v2.1.0/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.21.0"
	"golang.org/x/crypto v0.21.0/go.mod"
	"golang.org/x/net v0.0.0-20190603091049-60506f45cf65/go.mod"
	"golang.org/x/net v0.22.0"
	"golang.org/x/net v0.22.0/go.mod"
	"golang.org/x/oauth2 v0.18.0"
	"golang.org/x/oauth2 v0.18.0/go.mod"
	"golang.org/x/sync v0.5.0"
	"golang.org/x/sync v0.5.0/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.18.0"
	"golang.org/x/sys v0.18.0/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.2/go.mod"
	"golang.org/x/text v0.14.0"
	"golang.org/x/text v0.14.0/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
	"google.golang.org/appengine v1.6.7"
	"google.golang.org/appengine v1.6.7/go.mod"
	"google.golang.org/protobuf v1.26.0-rc.1/go.mod"
	"google.golang.org/protobuf v1.26.0/go.mod"
	"google.golang.org/protobuf v1.33.0"
	"google.golang.org/protobuf v1.33.0/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c"
	"gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c/go.mod"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	"gopkg.in/yaml.v2 v2.4.0"
	"gopkg.in/yaml.v2 v2.4.0/go.mod"
	"gopkg.in/yaml.v3 v3.0.1"
	"gopkg.in/yaml.v3 v3.0.1/go.mod"
	)
go-module_set_globals

DESCRIPTION="Prometheus exporter for memcached"
HOMEPAGE="https://github.com/prometheus/memcached_exporter"
SRC_URI="https://github.com/prometheus/memcached_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz
${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-util/promu"
DEPEND="acct-group/memcached_exporter
	acct-user/memcached_exporter"
RDEPEND="${DEPEND}"


# tests require the memcached_exporter daemon to be running locally
RESTRICT+=" test "

src_prepare() {
	default
	sed -i \
		-e "s/{{.Branch}}/HEAD/" \
		-e "s/{{.Revision}}/${GIT_COMMIT}/" \
		.promu.yml || die "sed failed"
}

src_compile() {
	promu build -v --prefix bin || die
}

src_install() {
	dobin bin/*
	dodoc *.md
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

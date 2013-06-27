EAPI="4"

inherit eutils git-2

DESCRIPTION="A fast, light-weight proxy for memcached and redis."

HOMEPAGE="https://github.com/twitter/twemproxy"
EGIT_REPO_URI="https://github.com/twitter/twemproxy"
#EGIT_COMMIT="v0.2.4"
LICENSE="apache2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-macos ~x86-solaris"

RDEPEND=""
DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup twemproxy
	enewuser twemproxy -1 -1 -1 twemproxy
}

src_configure() {
	autoreconf -fvi
	econf
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	insinto /etc/
	newins conf/nutcracker.yml nutcracker.yml
	fowners twemproxy:twemproxy /etc/nutcracker.yml
	fperms 0644 /etc/nutcracker.yml

	dodir /var/run/twemproxy
	fowners twemproxy:twemproxy /var/run/twemproxy

	newinitd "${FILESDIR}/twemproxy.initd" twemproxy

	dosbin src/nutcracker
}

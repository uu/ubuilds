# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Fake sshd that logs ip addresses, usernames, and passwords."
HOMEPAGE="https://github.com/droberson/ssh-honeypot"
EGIT_REPO_URI="https://github.com/droberson/ssh-honeypot.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	net-libs/libssh[server]
	dev-libs/json-c"

src_install() {
	dobin bin/${PN}
	newinitd "${FILESDIR}/${PN}.init" ${PN}
	newconfd "${FILESDIR}/${PN}.conf" ${PN}
	dodir usr/share/ssh-honeypot/
}

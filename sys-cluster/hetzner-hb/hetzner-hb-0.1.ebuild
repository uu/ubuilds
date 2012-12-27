# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4


DESCRIPTION="Hetzner hetzner-hb daemon"
HOMEPAGE="http://github.com/mrkamel/heartbeat"
SRC_URI=""

EGIT_REPO_URI="git://github.com/uu/heartbeat.git"
EGIT_BRANCH="master"

#USE_RUBY="ruby18"


LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="examples"

inherit eutils git-2

DEPEND="
	dev-ruby/httparty
	dev-ruby/rake
	dev-ruby/bundler
	dev-ruby/mocha
	"
RDEPEND="${DEPEND}"

src_install(){
	dodir /opt/hetzner-hb/lib
	insinto /opt/hetzner-hb/lib
	doins lib/*
	dodir /opt/hetzner-hb/bin
	insinto /opt/hetzner-hb/bin
	doins bin/heartbeat
	dodir /opt/hetzner-hb/config
	insinto /opt/hetzner-hb/config
	newins config/heartbeat.yml heartbeat.yml.example
	dodir /opt/hetzner-hb/log
	keepdir /opt/hetzner-hb/log
	dodir /opt/hetzner-hb/hooks
	keepdir /opt/hetzner-hb/hooks

	if use examples; then
		einfo "Installing examples"
		dodir /opt/hetzner-hb/examples/hooks
		insinto /opt/hetzner-hb/examples/hooks
		doins examples/hooks/email
	fi
	newinitd "${FILESDIR}/${PN}.init" hetzner-hb || die
	newconfd "${FILESDIR}/${PN}.conf" hetzner-hb || die
}


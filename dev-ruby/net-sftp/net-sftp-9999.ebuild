# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/net-sftp/net-sftp-2.0.5.ebuild,v 1.7 2012/05/01 18:24:27 armin76 Exp $

EAPI="4"
USE_RUBY="ruby19"

RUBY_FAKEGEM_TASK_DOC="doc"

RUBY_FAKEGEM_EXTRADOC=""
EGIT_REPO_URI="git://github.com/net-ssh/net-sftp.git"

inherit ruby git-2

DESCRIPTION="SFTP in pure Ruby"
HOMEPAGE="http://net-ssh.rubyforge.org/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="2"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""


S="${WORKDIR}"

src_install() {
	${RUBY} setup.rb install --prefix="${D}" "$@" \
	${RUBY_ECONF} || die "setup.rb install failed"
}


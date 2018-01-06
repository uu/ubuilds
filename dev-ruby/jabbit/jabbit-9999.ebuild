# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-odbc/ruby-odbc-0.99991-r1.ebuild,v 1.6 2012/05/01 18:24:10 armin76 Exp $

EAPI=5

USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md LICENSE"
RUBY_FAKEGEM_NAME="jabbit"
RUBY_FAKEGEM_GEMSPEC=${RUBY_FAKEGEM_NAME}.gemspec

inherit ruby-fakegem git-r3

DESCRIPTION="Jabber via RabbitMQ proxy."
HOMEPAGE="https://github.com/uu/jabbit"
SRC_URI=""
EGIT_REPO_URI="https://github.com/uu/jabbit.git"

LICENSE="|| ( GPL-2 Ruby )"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

ruby_add_rdepend '
     >=dev-ruby/settingslogic-2.0.8
	 >=dev-ruby/xmpp4r-0.5-r1
     >=dev-ruby/bunny-1.3.1'


DEPEND=">=dev-ruby/settingslogic-2.0.8
	 >=dev-ruby/xmpp4r-0.5-r1
	 >=dev-ruby/amq-protocol-1.0.1
	 dev-ruby/json
     >=dev-ruby/bunny-1.3.1"
RDEPEND="${DEPEND}"

RESTRICT=test

all_ruby_install() {
     all_fakegem_install
     newinitd "${FILESDIR}/${PN}.init" ${PN} || die
}

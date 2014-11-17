# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-odbc/ruby-odbc-0.99991-r1.ebuild,v 1.6 2012/05/01 18:24:10 armin76 Exp $

EAPI=5

# ruby19 → fails to build
# jruby → uses C extensions
USE_RUBY="ruby19"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md LICENSE"
RUBY_FAKEGEM_NAME="redis"
RUBY_FAKEGEM_GEMSPEC=${RUBY_FAKEGEM_NAME}.gemspec

#S=${WORKDIR}
WORKDIR="${WORKDIR}/all/${P}"

inherit ruby-fakegem 
#git-2

DESCRIPTION="A Ruby client library for Redis."
HOMEPAGE="http://github.com/redis/redis-rb"
#SRC_URI=""
#EGIT_REPO_URI="git://github.com/redis/redis-rb.git"

LICENSE="|| ( GPL-2 Ruby )"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

#ruby_add_rdepend '
#     >=dev-ruby/settingslogic-2.0.8


DEPEND=""
RDEPEND="${DEPEND}"

RESTRICT=test

all_ruby_install() {
     all_fakegem_install
	#newinitd "${FILESDIR}/${PN}.init" ${PN} || die
}


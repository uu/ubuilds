# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"
USE_RUBY="ruby18 ruby19"

inherit ruby-fakegem

DESCRIPTION="UNIX shell which uses pure Ruby syntax"
HOMEPAGE="http://rush.heroku.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
ruby_add_rdepend "dev-ruby/settingslogic dev-ruby/session dev-ruby/fattr"

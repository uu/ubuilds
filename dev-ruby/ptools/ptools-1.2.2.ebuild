# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_EXTRADOC="README"
USE_RUBY="ruby18 ruby19 ruby20 ruby21"

inherit ruby-fakegem

DESCRIPTION="Additional set of commands for the File class based on Unix command line tools."
HOMEPAGE="http://rubyforge.org/projects/shards"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
#ruby_add_rdepend "dev-ruby/settingslogic dev-ruby/session dev-ruby/fattr"

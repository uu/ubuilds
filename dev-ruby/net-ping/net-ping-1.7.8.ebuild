# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_EXTRADOC="README.md"
USE_RUBY="ruby18 ruby19 ruby20 ruby21 ruby22"

inherit ruby-fakegem

DESCRIPTION="The net-ping library provides a ping interface for Ruby. Net::Ping"
HOMEPAGE="https://rubygems.org/gems/net-ping/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
#ruby_add_rdepend "dev-ruby/ptools"

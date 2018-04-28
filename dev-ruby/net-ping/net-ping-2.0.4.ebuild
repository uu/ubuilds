# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_EXTRADOC="README.md"
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

inherit ruby-fakegem

DESCRIPTION="The net-ping library provides a ping interface for Ruby. Net::Ping"
HOMEPAGE="https://rubygems.org/gems/net-ping/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

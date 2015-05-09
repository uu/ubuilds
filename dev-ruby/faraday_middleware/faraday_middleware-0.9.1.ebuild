# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/faraday/faraday-0.7.4.ebuild,v 1.3 2011/07/24 20:09:06 tomka Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem eutils

DESCRIPTION="A collection of some useful Faraday middleware."
HOMEPAGE="http://github.com/technoweenie/faraday"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/faraday-0.7.4"

ruby_add_bdepend "test? ( dev-ruby/rash dev-ruby/simple_oauth )"

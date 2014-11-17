# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_EXTRADOC="README.mdown"
USE_RUBY="ruby18 ruby19 ruby20 ruby21"

inherit ruby-fakegem

DESCRIPTION="Copying and syncing extension to Net::FTP"
HOMEPAGE="http://github.com/zpendleton/ftp-ext"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
ruby_add_rdepend "dev-ruby/ptools"

# Copyright 2008-2011 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

inherit ruby-fakegem

DESCRIPTION="Ruby integrations for Elasticsearch"
HOMEPAGE="https://github.com/elasticsearch/elasticsearch-ruby"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

ruby_add_rdepend "=app-admin/fluentd-0.10*"

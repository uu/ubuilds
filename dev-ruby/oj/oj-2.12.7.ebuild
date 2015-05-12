# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"


inherit multilib ruby-fakegem

DESCRIPTION="A fast JSON parser and Object marshaller as a Ruby gem."
HOMEPAGE="https://github.com/ohler55/oj"
SRC_URI=""

LICENSE="GPL"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"



# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools
DESCRIPTION="An open-source C++ library developed and used at Facebook"
HOMEPAGE="https://github.com/facebook/folly"
SRC_URI="https://github.com/facebook/folly/archive/v${PV}.tar.gz"

LICENSE="Apache-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/boost[context]
dev-libs/double-conversion
dev-cpp/gflags
dev-cpp/glog"

RDEPEND="${DEPEND}"
S=${S}/folly

src_prepare() {
	eautoreconf
}


# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils autotools

DESCRIPTION="Mcrouter is a memcached protocol router for scaling memcached deployments."
HOMEPAGE="https://github.com/facebook/mcrouter"
SRC_URI="https://github.com/facebook/mcrouter/archive/v${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
net-misc/memcached
dev-libs/double-conversion
dev-cpp/gflags
dev-cpp/glog"
RDEPEND="${DEPEND}"

S=${S}/mcrouter

src_prepare() {
	eautoreconf
}

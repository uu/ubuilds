# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="The couchbase client for C."
HOMEPAGE="https://github.com/couchbase/libcouchbase"
SRC_URI="http://packages.couchbase.com/clients/c/libcouchbase-2.0.6.tar.gz"

LICENSE="Apache 2.0"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="sasl"

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	myconf="${myconf} --disable-tests --disable-couchbasemock"
	if use sasl; then
		myconf="${myconf} --enable-system-libsasl"
	fi
	econf ${myconf}
}

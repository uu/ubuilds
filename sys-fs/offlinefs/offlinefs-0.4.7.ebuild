# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools

DESCRIPTION="FUSE filesystem initially intended to join a
large collection of ejectable media like CDs and DVDs"
HOMEPAGE="http://savannah.nongnu.org/projects/offlinefs/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="kde"

COMMONDEPEND="dev-libs/boost
	|| ( sys-libs/db:4.5 sys-libs/db:4.6 sys-libs/db:4.7 )
	sys-fs/fuse"

DEPEND="${COMMONDEPEND}
	sys-apps/attr"

RDEPEND="${COMMONDEPEND}
	kde? ( kde-base/kdialog )"

src_prepare() {
	if has_version sys-libs/db:4.7; then
		einfo "sys-libs/db:4.7 detected"
		sed s/'AC_CHECK_LIB(\[db_cxx\]'/'AC_CHECK_LIB(\[db_cxx-4.7\]'/ -i configure.in || die
	elif has_version sys-libs/db:4.6; then
		einfo "sys-libs/db:4.6 detected"
		sed s/'AC_CHECK_LIB(\[db_cxx\]'/'AC_CHECK_LIB(\[db_cxx-4.6\]'/ -i configure.in || die
	elif has_version sys-libs/db:4.5; then
		einfo "sys-libs/db:4.5 detected"
		sed s/'AC_CHECK_LIB(\[db_cxx\]'/'AC_CHECK_LIB(\[db_cxx-4.5\]'/ -i configure.in || die
	fi
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit scons-utils eutils git-r3 multilib

DESCRIPTION="rmlint finds space waste and other broken things on your filesystem."
HOMEPAGE="https://github.com/sahib/rmlint"
SRC_URI=""
EGIT_REPO_URI="https://github.com/sahib/rmlint.git"
EGIT_BRANCH="master"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="doc +nls"

RDEPEND="
	dev-libs/elfutils
	>=dev-libs/glib-2.32
	dev-libs/json-glib
	sys-apps/util-linux
	sys-libs/glibc"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	doc? ( dev-python/sphinx )"

src_compile() {
	COMP_FLAGS=CC="\"$(tc-getCC)\" --prefix=${D}/usr --actual-prefix=/usr --libdir=/usr/$(get_libdir)"
	if ! use nls; then
		COMP_FLAGS += "--without-gettext"
	fi

	escons "${COMP_FLAGS}"
}

src_install(){
	escons install LIBDIR=/usr/$(get_libdir) --prefix="${ED}"/usr
	rm -f "${D}"/usr/share/glib-2.0/schemas/gschemas.compiled
	if ! use doc; then
		rm -rf "${D}"/usr/share/man
	fi
}

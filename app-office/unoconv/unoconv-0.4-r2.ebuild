# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/storm/storm-0.13.ebuild,v 1.1 2008/10/26 05:04:25 neurogeek Exp $

EAPI="2"

inherit eutils

DESCRIPTION="Convert between any document format supported by OpenOffice"
HOMEPAGE="http://dag.wieers.com/home-made/unoconv/"
SRC_URI="http://dag.wieers.com/home-made/unoconv/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc libreoffice"

RDEPEND=">=dev-lang/python-2.5"
DEPEND="dev-python/setuptools
	libreoffice? ( app-office/libreoffice-bin ) 
	doc? ( app-text/asciidoc )"

src_prepare() {
	epatch "${FILESDIR}/${P}-empty-ld-library-path.patch"
}

src_compile ()
{
	if use doc; then
		emake -C docs docs
	fi
}

src_install() {
	emake install DESTDIR="${D}"

	if use doc; then
		dohtml docs/*.html || die "Can't install documentation."
	fi
}

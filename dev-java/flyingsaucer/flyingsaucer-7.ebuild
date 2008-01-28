# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jsr101/jsr101-1.1.ebuild,v 1.5 2007/12/05 19:59:50 nelchael Exp $

JAVA_PKG_IUSE=""

inherit java-pkg-2

DESCRIPTION="100% Java XHTML+CSS renderer"
HOMEPAGE="100% Java XHTML+CSS renderer"
SRC_URI="http://www.pdoubleya.com/projects/${PN}/downloads/r${P}/${PN}-R${PV}final.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_compile() {
	:
}

src_install() {
	java-pkg_dojar core-renderer.jar core-renderer-minimal.jar itext-paulo-155.jar minium.jar
}

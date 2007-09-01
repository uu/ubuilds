# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/zemberek/zemberek-2.0.ebuild,v 1.2 2007/08/04 19:34:24 mr_bones_ Exp $

inherit eutils java-pkg-2 java-ant-2 autotools

DESCRIPTION="MTPSynchronizer is a very simple interface for adding, deleting and retrieving content from your MTP device, with a Linux desktop"
HOMEPAGE="http://code.google.com/p/jmtpsynchronizer/"
SRC_URI="http://jmtpsynchronizer.googlecode.com/files/jmtpsynchronizer-1.0-r58-beta3.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/${PN}"

CDEPEND="dev-java/entagged-audioformats
	media-libs/libmtp" #Instructions say >=0.2.1 needs testing

RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.4
	${CDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}/JMtpSynchronizer" || die "cd \"JMtpSynchronizer\" failed"
	rm -f lib/entagged-audioformats-0.15.jar dist/*.jar || die "rm failed"
	java-pkg_jarfrom entagged-audioformats entagged-audioformats.jar lib/entagged-audioformats-0.15.jar
	sed -i -e 's:EXIT_ON_CLOSE:DISPOSE_ON_CLOSE:g' src/com/mtpsynchronizer/ChooseFolderDialog.java || die "sed failed"
}

src_compile() {
	cd "${S}/mtpSync" || die "cd \"mtpSync\" failed"
	econf
	cd "${S}/JMtpSynchronizer" || die "cd \"JMtpSynchronizer\" failed"
	eant build
}

src_install() {
	cd "${S}/mtpSync" || die "cd \"mtpSync\" failed"
	einstall
	cd "${S}/JMtpSynchronizer" || die "cd \"JMtpSynchronizer\" failed"
	java-pkg_dojar dist/JMtpSynchronizer.jar
	java-pkg_dolauncher ${PN} --main com.mtpsynchronizer.MainFrame
}

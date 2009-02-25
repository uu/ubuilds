# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-ant-2 autotools

DESCRIPTION="MTPSynchronizer is a very simple interface for adding, deleting and retrieving content from your MTP device, with a Linux desktop"
HOMEPAGE="http://code.google.com/p/jmtpsynchronizer/"
SRC_URI="http://jmtpsynchronizer.googlecode.com/files/jmtpsynchronizer-1.0-r107-beta6.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

S="${WORKDIR}/${PN}"

CDEPEND="dev-java/entagged-audioformats
	>=media-libs/libmtp-0.2.1
	>=dev-libs/libxml2-2.6.30"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.5
	dev-util/pkgconfig
	${CDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}/JMtpSynchronizer" || die
	rm -f lib/entagged-audioformats-0.15.jar dist/*.jar || die
	java-pkg_jarfrom entagged-audioformats entagged-audioformats.jar lib/entagged-audioformats-0.15.jar
	epatch "${FILESDIR}/${PN}"-fixbinpath.patch
}

src_compile() {
	cd "${S}/mtpSync" || die
	econf
	cd "${S}/JMtpSynchronizer" || die
	eant build
}

src_install() {
	cd "${S}/mtpSync" || die
	einstall
	cd "${S}/JMtpSynchronizer" || die
	java-pkg_dojar dist/JMtpSynchronizer.jar
	java-pkg_dolauncher ${PN} --main com.mtpsynchronizer.MainFrame
}

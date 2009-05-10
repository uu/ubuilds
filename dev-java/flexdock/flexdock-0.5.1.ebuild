# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-ant-2 toolchain-funcs

DESCRIPTION="Java docking framework for use in cross-platform Swing applications"
HOMEPAGE="http://flexdock.dev.java.net/"
SRC_URI="http://flexdock.dev.java.net/files/documents/2037/52480/${P}-src.zip"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

RDEPEND=">=virtual/jre-1.4
	dev-java/commons-logging
	dev-java/skinlf"

DEPEND="${RDEPEND}
	>=virtual/jdk-1.4
	app-arch/unzip"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/buildfixes.patch"
	cd lib
	rm -v *.jar || die
	java-pkg_jar-from commons-logging
	java-pkg_jar-from skinlf
}

src_compile() {
	eant -DCC=$(tc-getCC) -Dsdk.home="${JAVA_HOME}" jar compile.native $(use_doc)
}

src_install() {
	java-pkg_newjar build/${P}.jar ${PN}.jar
	java-pkg_doso build/bin/org/flexdock/docking/drag/outline/xlib/libRubberBand.so
	dodoc release-notes.txt README* || die
	use doc && java-pkg_dojavadoc build/docs/api
}

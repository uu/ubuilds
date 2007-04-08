# Copyright 1999-2005 Gentoo Foundation
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
	 dev-java/commons-logging"

DEPEND="${RDEPEND}
	>=virtual/jdk-1.4
	app-arch/unzip"

src_unpack() {
	mkdir -p ${S}
	cd ${S} && unpack ${A}
	epatch ${FILESDIR}/buildfixes.patch
	cd lib
	rm commons-logging-1.1.jar
	java-pkg_jar-from commons-logging commons-logging.jar commons-logging-1.1.jar
}

src_compile() {
	local anttasks_opt
	use doc && anttasks_opt="javadoc"
	eant -DCC=$(tc-getCC) -Dsdk.home=$JAVA_HOME jar compile.native ${anttasks_opt}
}

src_install() {
	java-pkg_newjar build/${P}.jar ${PN}.jar
	java-pkg_doso build/bin/org/flexdock/docking/drag/outline/xlib/libRubberBand.so
	use doc && java-pkg_dojavadoc build/docs/api
	dodoc release-notes.txt README*
}

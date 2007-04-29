# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/aoi/aoi-2.2.1.ebuild,v 1.3 2007/03/27 06:09:15 opfer Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 eutils

MY_PV="${PV//./}"
MY_MANUAL_V="2.4"
DESCRIPTION="A free, open-source 3D modelling and rendering studio."
SRC_URI="mirror://sourceforge/aoi/${PN}src${MY_PV}.zip"
#	doc? ( mirror://sourceforge/aoi/manual${MY_MANUAL_V}.zip )"
HOMEPAGE="http://aoi.sourceforge.net/index"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"

COMMON_DEPEND="
	dev-java/bsh
	dev-java/helpgui
	dev-java/javahelp
	dev-java/jogl
	"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEPEND}"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"

S="${WORKDIR}/AoIsrc${MY_PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -v *.jar HelpPlugin/lib/*jar		

	java-pkg_jar-from bsh bsh.jar beanshell.jar
#	java-pkg_jar-from buoy buoy.jar Buoy.jar
#	java-pkg_jar-from buoyx buoyx.jar Buoyx.jar
	java-pkg_jar-from bsh bsh.jar beanshell.jar
	java-pkg_jar-from jogl 

	cd HelpPlubin/lib
	java-pkg_jar-from helpgui helpgui.jar helpgui-1.1a.jar
	java-pkg_jar-from javahelp jhall.jar
#	java-pkg_jar-from jhelpaction jhelpaction.jar
#	java-pkg_jar-from pircbot pircbot.jar

}

EANT_BUILD_XML="ArtOfIllusion.xml"
EANT_BUILD_TARGET="dist"
EANT_DOC_TARGET="docs"

src_install() {
	# wrapper script
	dobin "${FILESDIR}"/aoi

	# documentation
	dodoc HISTORY README
	if use doc ; then
		mv "${WORKDIR}"/AoI\ Manual/ "${WORKDIR}"/aoi_manual
		dohtml -r "${WORKDIR}"/aoi_manual/
	fi

	# main app
	java-pkg_dojar ArtOfIllusion.jar

	# plugins
	mv Plugins "${D}"/usr/share/${PN}/lib

	# scripts
	mv Scripts "${D}"/usr/share/${PN}/lib

	# icon
	mv Icons/64x64.png Icons/aoi.png
	doicon Icons/aoi.png

	# desktop entry
	java-pkg_dolauncher aoi "Art of Illusion" /usr/share/pixmaps/aoi.png "Graphics"
}

# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2

DESCRIPTION="GPL audio player and manager"
HOMEPAGE="http://www.atunes.org/"
SRC_URI="mirror://sourceforge/${PN}/aTunes_${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

CDEPEND="dev-java/htmlparser
	dev-java/jaudiotagger
	dev-java/log4j
	=dev-java/jakarta-oro-2.0*
	=dev-java/jfreechart-1.0*
	=dev-java/jcommon-1.0*
	dev-java/swingx
	dev-java/jdictrayapi
	dev-java/commons-io
	dev-java/filters
	dev-java/substance
	dev-java/laf-widget"

RDEPEND="=virtual/jre-1.6*
	media-sound/vorbis-tools
	media-libs/flac
	media-sound/lame
	media-video/mplayer
	|| ( app-cdr/cdrtools app-cdr/cdrkit )
	${CDEPEND}"

DEPEND="=virtual/jdk-1.6*
	${CDEPEND}"

S=${WORKDIR}/aTunes

src_unpack() {
	unpack ${A}
	mv "${S}"/lib/antBuildNumber.jar -v "${S}"
	rm -rfv "${S}"/{lib,win_tools,aTunes.jar}
	sed -i -e 's:aTunes.log:${user.home}/.aTunes/aTunes.log:g' "${S}"/log4j.properties
}

src_compile() {
	cd src
	classpath=$(java-pkg_getjars htmlparser,jaudiotagger,log4j,jakarta-oro-2.0,jfreechart-1.0,jcommon-1.0,swingx,jdictrayapi,commons-io-1,filters)
	classpath=${classpath}:$(java-pkg_getjar substance substance.jar):$(java-pkg_getjar laf-widget laf-widget.jar)
	find . -name '*.java' -print > sources.list
	ejavac -encoding ISO-8859-1 -classpath .:${classpath}:../antBuildNumber.jar @sources.list
	find . -name '*' -not -name '*.java' -type f -not -name 'classes.list' -print > classes.list
	touch myManifest
	jar cmf myManifest ../${PN}.jar @classes.list
}

src_install() {
	java-pkg_dojar *.jar
	java-pkg_dolauncher ${PN} --main net.sourceforge.atunes.Main --pwd /usr/share/atunes
	newicon src/net/sourceforge/atunes/gui/images/appIcon.png ${PN}.png
	make_desktop_entry ${PN} "aTunes" ${PN}.png
	dodoc license.txt
	insinto /usr/share/atunes
	doins *.properties
	doins -r translations
}

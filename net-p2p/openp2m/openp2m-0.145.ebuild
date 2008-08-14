# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2

DESCRIPTION="OpenSource software for share file through e-mail"
HOMEPAGE="http://openp2m.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/OpenP2M-src.v${PV}.zip"
LICENSE="MPL-1.0"
SLOT="0"
IUSE=""
KEYWORDS="~x86 ~amd64"

CDEPEND="=dev-java/commons-httpclient-3*
	dev-java/swing-layout
	dev-java/sun-javamail
	dev-java/commons-codec
	dev-java/commons-net
	=dev-java/dnsjava-1.3.2
	dev-java/javahelp
	dev-java/commons-email"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	mv src-core src
	cp -Rf src-systray-6/* src
	rm -rf src-systray-*
}

src_compile() {
	cd src
	classpath=${classpath}:$(java-pkg_getjars commons-httpclient-3,swing-layout-1,sun-javamail,commons-codec,commons-net,commons-email,dnsjava-1.3.2):$(java-pkg_getjar javahelp jh.jar)
	find . -name '*.java' -print > sources.list
	#Replaces Key with 34567. What else can be done? (maybe generate random et build time)
	#Don't know how its exactly used but seems encryption related
	find . -name '*.java' -exec sed -i -e "s:CHAVE:34567:g" '{}' \;
	ejavac -encoding ISO-8859-1 -classpath .:${classpath} @sources.list
	find . -name '*' -not -name '*.java' -type f -not -name 'classes.list' -print > classes.list
  	touch myManifest
  	jar cmf myManifest ../${PN}.jar @classes.list
}

src_install() {
	java-pkg_dojar ${PN}.jar
	java-pkg_dolauncher ${PN} --main gui.MainSystray
	doicon ${FILESDIR}/${PN}.png
	make_desktop_entry ${PN} "OpenP2M" ${PN}.png
}

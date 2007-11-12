# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2

DESCRIPTION="Facebook photo uploader."
HOMEPAGE="http://openp2m.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/OpenP2M-src.v${PV}.zip"
LICENSE="MPL-1.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="java6"
#TODO: package comons-email as a dep
CDEPEND="=dev-java/commons-httpclient-3*
	dev-java/swing-layout
	dev-java/sun-javamail
	dev-java/commons-codec
	dev-java/commons-net
	=dev-java/dnsjava-1.3.2
	dev-java/javahelp
	!java6? ( dev-java/jdictrayapi )"
RDEPEND="!java6? ( >=virtual/jre-1.4 )
	java6? ( >=virtual/jre-1.6 )
	${CDEPEND}"

DEPEND="!java6? ( >=virtual/jdk-1.4 )
	java6? ( >=virtual/jdk-1.6 )
	${CDEPEND}"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	mv src-core src
	use java6 && cp -Rf src-systray-6/* src
	! use java6 && cp -Rf src-systray-5/* src
	rm -rf src-systray-*
}

compile_into_jar() {
	cd $1
	find . -name '*.java' -print > sources.list
	ejavac -cp .:$3 @sources.list
	find . -name '*' -not -name '*.java' -type f -not -name 'classes.list' -print > classes.list
  	touch myManifest
  	jar cmf myManifest ../dist/$2.jar @classes.list
}

src_compile() {
	cd src
	! use java6 && classpath=$(java-pkg_getjars jdictrayapi)
	classpath=${classpath}:$(java-pkg_getjars commons-httpclient-3,swing-layout-1,sun-javamail,commons-codec,commons-net,dnsjava-1.3.2):$(java-pkg_getjar javahelp jh.jar)
	find . -name '*.java' -print > sources.list
	ejavac -cp .:${classpath} @sources.list
	find . -name '*' -not -name '*.java' -type f -not -name 'classes.list' -print > classes.list
  	touch myManifest
  	jar cmf myManifest ../${PN}.jar @classes.list
}

src_install() {
	java-pkg_dojar dist/${PN}-core.jar
	java-pkg_dojar dist/${PN}-tray.jar
	#java-pkg_dolauncher fb-photo-uploader --main uk.me.phillsacre.uploader.FacebookUploader
}

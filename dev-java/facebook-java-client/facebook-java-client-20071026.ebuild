# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java Client API for Facebook social network"
HOMEPAGE="http://developers.facebook.com/resources.php"
SRC_URI="facebook_java_client-${PV}.zip"

DOWNLOAD_URI="http://developers.facebook.com/clientlibs/facebook_java_client.zip"

LICENSE="facebook"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="examples"

RESTRICT="fetch"

COMMON_DEPS="dev-java/json-simple"

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEPS}"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPS}"

S="${WORKDIR}"

pkg_nofetch() {
	ewarn
	ewarn "Facebook uses broken file naming, all versions of ${PN}"
	ewarn "facebook_java_client.zip"
	ewarn
	ewarn "Please download following file:"
	ewarn " ${DOWNLOAD_URI}"
	ewarn "and move it to:"
	ewarn " ${DISTDIR}/${SRC_URI}"
	ewarn
}

src_unpack() {
	unpack ${A}
	rm -rf bin || die "rm failed"
	mkdir examples || "mkdir \"examples\" failed"
	mkdir src || "mkdir \"src\" failed"
	mv com/facebook/api/ExampleClient.java examples
	mv settings.conf examples
	mv com src/com
}

src_compile() {
	cd src
	find . -name '*.java' -print > sources.list
	ejavac -cp .:$(java-pkg_getjars json-simple) @sources.list
	find . -name '*.class' -print > classes.list
	touch myManifest
  	jar cmf myManifest ${PN}.jar @classes.list
}

src_install() {
	java-pkg_dojar src/${PN}.jar
	use source && java-pkg_dosrc src/*
	use examples && java-pkg_doexamples examples/*
	dodoc README CHANGELOG
}

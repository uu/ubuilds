# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc"

inherit eutils java-pkg-2 java-ant-2 versionator

DESCRIPTION="A mature Java-based RSS/RDF/Atom Newsreader with advanced features."

HOMEPAGE="http://www.rssowl.org/"
LICENSE="EPL-1.0"

#MY_P="${PN}_$(replace_version_separator 2 '.' ${PV/./_})_src"
MY_P="${PN}_${PV//./_}_src"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

CDEPEND="dev-java/commons-codec
		dev-java/jdom
		dev-java/commons-logging
		>=dev-java/commons-httpclient-3
		>=dev-java/xerces-2
		dev-java/blowfishj
		dev-java/itext
		>=dev-java/swt-3.2
		=dev-java/eclipse-jface-3*
		=dev-java/eclipse-core-commands-3*"

DEPEND=">=virtual/jdk-1.4
		${CDEPEND}"
RDEPEND=">=virtual/jre-1.4
		${CDEPEND}"


src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}/${PN}-unjar-build-fix.patch"

	cd "${S}/lib"
	mv res.jar swt-nl.jar "${S}" || die
	rm -v *.jar
}

#EANT_BUILD_TARGET="deploy_linux"

src_compile() {
	cd "${S}/src"
	local cp="$(java-pkg_getjars jdom-1.0,itext,blowfishj,commons-codec,commons-httpclient-3,commons-logging,xerces-2,swt-3,eclipse-jface-3,eclipse-core-commands-3)"
	eant -Djava.io.tmpdir="${T}" -Dlibs="${cp}" deploy_linux $(use_doc)
}

src_install() {
	java-pkg_dojar "${PN}.jar"
	java-pkg_dojar swt-nl.jar
	java-pkg_dojar res.jar

	java-pkg_dolauncher rssowl \
		--main net.sourceforge.rssowl.controller.RSSOwlLoader

	doicon "img/${PN}.xpm"

	make_desktop_entry rssowl "RSSOwl" rssowl

	dodoc doc/{CHANGELOG.txt,README.txt} || die
	use doc && java-pkg_dojavadoc doc/api/
}

pkg_postinst() {
	if ! built_with_use dev-java/swt seamonkey && ! built_with_use dev-java/swt xulrunner; then
		ewarn "dev-java/swt should be compiled with the seamonkey or xulrunner use flag"
		ewarn "for the internal browser to work"
	fi
}

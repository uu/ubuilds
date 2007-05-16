# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc seamonkey"

inherit eutils flag-o-matic java-pkg-2 java-ant-2 versionator

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
		dev-java/itext"

DEPEND=">=dev-java/swt-3.2
		>=virtual/jdk-1.4
		${CDEPEND}"
RDEPEND=">=virtual/jre-1.4
		>=dev-java/swt-3.2
		seamonkey? ( >=www-client/seamonkey-1.0.2 )
		${CDEPEND}"

pkg_setup() {
	if use seamonkey && ! built_with_use dev-java/swt seamonkey; then
		ewarn "dev-java/swt should be compiled with the seamonkey use flag"
		ewarn "when you have the seamonkey use flag set"
		die
	fi
}

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}/${PN}-unjar-build-fix.patch"

	cd "${S}/lib"

	java-pkg_jar-from jdom-1.0
	java-pkg_jar-from itext iText.jar itext.jar
	java-pkg_jar-from blowfishj blowfishj.jar BlowfishJ.jar
	java-pkg_jar-from commons-codec commons-codec.jar \
		codec-1.3.jar
	java-pkg_jar-from commons-httpclient-3 commons-httpclient.jar \
		httpclient-3.0.1.jar
	java-pkg_jar-from commons-logging commons-logging.jar logging-1.0.4.jar
	java-pkg_jar-from xerces-2 xercesImpl.jar xerces.jar
	java-pkg_jar-from swt-3
}

#EANT_BUILD_TARGET="deploy_linux"

src_compile() {
	cd "${S}/src"
	eant deploy_linux $(use_doc)
}

src_install() {
	java-pkg_dojar "${PN}.jar"
	java-pkg_dojar lib/jface.jar
	java-pkg_dojar lib/swt-nl.jar
	java-pkg_dojar lib/iTextAsian.jar
	java-pkg_dojar lib/res.jar

	# Create program launcher
	#if use seamonkey ; then
#		echo -e "#!/bin/sh\nexport MOZILLA_FIVE_HOME=/usr/lib/seamonkey\nexec java -Dnet.sourceforge.rssowl.noSplash -Djava.library.path=/usr/lib/ -jar /usr/share/${PN}/lib/${PN}.jar \"\$@\"" > ./${PN}
#	else
#		echo -e "#!/bin/sh\nexec java -Dnet.sourceforge.rssowl.noSplash -Djava.library.path=/usr/lib/ -jar /usr/share/${PN}/lib/${PN}.jar \"\$@\"" > ./${PN}
#	fi

	java-pkg_dolauncher rssowl \
		--main net.sourceforge.rssowl.controller.RSSOwlLoader

	#dobin ${PN}

	doicon "img/${PN}.xpm"

	make_desktop_entry rssowl "RSSOwl" rssowl

	use doc && java-pkg_dojavadoc doc/api/
	dodoc doc/{CHANGELOG.txt,README.txt}
}


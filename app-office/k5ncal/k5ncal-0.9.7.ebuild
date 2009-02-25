# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit java-pkg-2 java-ant-2

MY_P="k5nCal-src-${PV}"

DESCRIPTION="The k5n Desktop Calendar (k5nCal, for short) is a Java-based calendar application for your desktop."
HOMEPAGE="http://www.k5n.us/k5ncal.php"
SRC_URI="mirror://sourceforge/k5ndesktopcal/${MY_P}.zip"

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

COMMON_DEP="dev-java/javacaltools:0
	dev-java/jcalendar:1.2
	dev-java/browserlauncher2:1.0
	dev-java/accordionpane:0"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	epatch "${FILESDIR}"/${P}-build.xml.patch
	epatch "${FILESDIR}"/${P}-remove-macstuff.patch
	cd lib || die
	mv k5nAccordion-1.0.1.jar ../k5nAccordion-1.0.1.jar
	rm -v *.jar
	mv ../k5nAccordion-1.0.1.jar .
	java-pkg_jar-from javacaltools ical.jar k5n-ical-0.4.6.jar
	java-pkg_jar-from javacaltools calendarpanel.jar k5n-calendarpanel-0.4.6.jar
	java-pkg_jar-from jcalendar-1.2 jcalendar.jar jcalendar-1.3.2.jar
	java-pkg_jar-from browserlauncher2-1.0 browserlauncher2.jar BrowserLauncher2-1_3.jar
	#java-pkg_jar-from accordionpane accordionpane.jar k5nAccordion-1.0.1.jar
	# fails with 1.0.0 and there's no 1.0.1 release
	# See https://sourceforge.net/tracker/index.php?func=detail&aid=2197109&group_id=195315&atid=952950
}

EANT_BUILD_TARGET="dist"

src_install() {
	java-pkg_newjar dist/k5nCal-${PV}.jar ${PN}.jar
	java-pkg_newjar lib/k5nAccordion-1.0.1.jar accordionpane-${PN}.jar
	# Temp. See comment above.
	java-pkg_dolauncher ${PN} --main us.k5n.k5ncal.Main
	dodoc ChangeLog README.txt
}


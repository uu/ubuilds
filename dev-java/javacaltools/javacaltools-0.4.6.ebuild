# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2 eutils

MY_P="k5n-all-src-${PV}"

DESCRIPTION="Various calendar-related libraries written in Java."
HOMEPAGE="http://javacaltools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RESTRICT="test"
#See https://sourceforge.net/tracker/index.php?func=detail&aid=2196842&group_id=151261&atid=780525

COMMON_DEP="dev-java/commons-codec:0
	dev-java/joda-time:0
	dev-java/javacsv:0
	dev-java/rfc2445:0"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	test? (
		dev-java/junit:0
		dev-java/ant-junit
	)
	app-arch/unzip
	${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	epatch "${FILESDIR}"/${P}-build.xml.patch
	cd lib || die
	rm -v *.jar
	java-pkg_jar-from commons-codec commons-codec.jar commons-codec-1.3.jar
	java-pkg_jar-from rfc2445 rfc2445.jar google-rfc2445.jar
	java-pkg_jar-from javacsv javacsv.jar
	java-pkg_jar-from joda-time joda-time.jar joda-time-1.4.jar
}

EANT_BUILD_TARGET="dist"

src_test() {
	java-pkg_jar-from --into lib junit junit.jar
	ANT_TASKS="ant-junit" eant "${cp}" test
}

src_install() {
	java-pkg_newjar dist/lib/k5n-ical-${PV}.jar ical.jar
	java-pkg_newjar dist/lib/k5n-calendarpanel-${PV}.jar calendarpanel.jar
	use doc && java-pkg_dojavadoc doc/{ical,calendarpanel}/api
	use source && java-pkg_dosrc src/us
	dodoc AUTHORS ChangeLog README.txt
}


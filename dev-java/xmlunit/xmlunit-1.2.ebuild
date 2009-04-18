# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xmlunit/xmlunit-1.0-r2.ebuild,v 1.6 2007/08/15 21:08:15 wltjr Exp $

JAVA_PKG_IUSE="doc source test"
inherit java-pkg-2 java-ant-2

DESCRIPTION="XMLUnit extends JUnit and NUnit to enable unit testing of XML."
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
HOMEPAGE="http://xmlunit.sourceforge.net/"
LICENSE="BSD"
SLOT="1"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
# We depend on jdk-1.4 as tests fail with jdk > 1.4
# see http://sourceforge.net/tracker/index.php?func=detail&aid=1614984&group_id=23187&atid=377768
# Also docs cannot be built with jdk > 1.5
CDEPEND="=dev-java/junit-3.8*"
DEPEND="
	app-arch/unzip
	>=virtual/jdk-1.4
	doc? ( app-text/docbook-xsl-stylesheets )
	test? (
		dev-java/ant-junit
		dev-java/ant-trax
	)
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PN}-${PVR}-build.xml.patch"

	java-ant_rewrite-classpath
}

EANT_DOC_TARGET="users-guide-html javadocs"
EANT_GENTOO_CLASSPATH="junit"
EANT_ANT_TASKS="ant-trax"
EANT_EXTRA_ARGS="-Ddb5.xsl=/usr/share/sgml/docbook/xsl-stylesheets"

src_test() {
	if use test; then
		ANT_TASKS="ant-junit ant-trax" eant test
	else
		echo "USE=test not enabled, skipping tests."
	fi
}

src_install() {
	java-pkg_newjar build/lib/${P}.jar

	dodoc README.txt
	if use doc ; then
		java-pkg_dojavadoc build/doc/api
		dohtml build/doc/userguide/html/*
	fi
	use source && java-pkg_dosrc src/java/org
}

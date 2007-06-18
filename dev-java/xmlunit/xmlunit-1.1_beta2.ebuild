# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xmlunit/xmlunit-1.0-r2.ebuild,v 1.4 2007/06/18 12:36:34 caster Exp $

JAVA_PKG_IUSE="doc source test"
inherit java-pkg-2 java-ant-2

DESCRIPTION="XMLUnit extends JUnit and NUnit to enable unit testing of XML."
MY_P=${P/_/}
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.zip"
HOMEPAGE="http://xmlunit.sourceforge.net/"
LICENSE="BSD"
SLOT="1"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	test? (
		dev-java/ant-junit
		dev-java/ant-trax
	)"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${MY_P}"

EANT_DOC_TARGET="javadocs"

src_test() {
	ANT_TASKS="ant-junit ant-trax" eant test
}

src_install() {
	java-pkg_newjar build/lib/${MY_P}.jar

	dodoc README.txt
	if use doc ; then
		java-pkg_dojavadoc build/doc/api
		dohtml userguide/html/*
	fi
	use source && java-pkg_dosrc src/java/org
}

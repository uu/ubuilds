# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xmlunit/xmlunit-1.0-r2.ebuild,v 1.4 2009/06/18 12:36:34 caster Exp $

JAVA_PKG_IUSE="doc source test"
inherit java-pkg-2 java-ant-2

DESCRIPTION="XMLUnit extends JUnit and NUnit to enable unit testing of XML."
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
HOMEPAGE="http://xmlunit.sourceforge.net/"
LICENSE="BSD"
SLOT="1"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
CDEPEND="=dev-java/junit-3.8*"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	test? (
		dev-java/ant-junit
		dev-java/ant-trax
	)
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	java-ant_rewrite-classpath
}

src_compile() {
	eant jar $(use_doc javadocs) -Dgentoo.classpath=$(java-pkg_getjars junit)
}

src_test() {
	ANT_TASKS="ant-junit ant-trax" eant test -Dgentoo.classpath=$(java-pkg_getjars junit)
}

src_install() {
	java-pkg_newjar build/lib/${P}.jar

	dodoc README.txt
	if use doc ; then
		java-pkg_dojavadoc build/doc/api
		dohtml userguide/html/*
	fi
	use source && java-pkg_dosrc src/java/org
}

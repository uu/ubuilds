# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java bytecode manipulation and developer utilities."
HOMEPAGE="http://serp.sourceforge.net/"
SRC_URI="${P}.tar.bz2" # CVS only

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	test? (	dev-java/junit:0 dev-java/ant-junit:0 )"

src_tarball() {
	cvs -z3 -d :pserver:anonymous@serp.cvs.sourceforge.net:/cvsroot/serp \
	co serp	|| die
	mv serp "${P}" || die
	rm -Rv `find "${P}/" -name CVS` || die
	tar cvjf "${P}.tar.bz2" "${P}" || die
	rm -Rv "${P}" || die
	echo "New tarball located at ${P}.tar.bz2"
}

src_prepare() {
	cp "${FILESDIR}/build.xml" . || die

	use test && ( \
		mkdir lib && cd lib/ || die
		java-pkg_jar-from --build-only junit
	)
}

src_test() {
	ANT_TASKS="ant-junit" eant test
}

src_install() {
	java-pkg_dojar "target/${PN}.jar"
	use doc && java-pkg_dojavadoc target/javadocs
	use source && java-pkg_dosrc src/main/java/serp
}

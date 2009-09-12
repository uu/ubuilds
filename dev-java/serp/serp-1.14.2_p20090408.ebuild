# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java bytecode manipulation and developer utilities."
HOMEPAGE="http://serp.sourceforge.net/"
# scm serp.cvs.sourceforge.net:/cvsroot/serp
SRC_URI="http://dev.gentoo.org/~serkan/distfiles/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip:0
	test? ( dev-java/ant-junit:0 )"

src_prepare() {
	cp "${FILESDIR}/build.xml" . || die

	use test && (
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

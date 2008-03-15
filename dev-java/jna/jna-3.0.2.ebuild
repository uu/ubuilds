# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="test doc source"
WANT_ANT_TASKS="ant-nodeps"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Java Native Access (JNA)"
HOMEPAGE="https://jna.dev.java.net/"
SRC_URI="http://ebuild.linux-sevenler.org/distfiles/${P}.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="!test? ( >=virtual/jdk-1.4 )
	test?
	(
		dev-java/junit
		dev-java/ant-junit
		dev-java/ant-trax
		>=virtual/jdk-1.5
	)"
RDEPEND="!test? ( >=virtual/jre-1.4 )
	test? ( >=virtual/jre-1.5 )"

#EANT_BUILD_TARGET="jar"
#RESTRICT="test"

src_unpack() {
	unpack ${A}
	use test && java-pkg_jar-from --build-only --into "${S}"/lib junit
}

src_install() {
	java-pkg_dojar build/${PN}.jar
	java-pkg_doso build/native/libjnidispatch.so
	use source && java-pkg_dosrc src/com
	use doc && java-pkg_dojavadoc doc/javadoc
}

src_test() {
	ANT_TASKS="ant-junit ant-nodeps ant-trax" eant test
}

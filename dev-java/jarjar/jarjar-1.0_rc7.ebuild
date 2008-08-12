# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jarjar/jarjar-0.9.ebuild,v 1.12 2008/01/16 20:17:04 armin76 Exp $

EAPI="1"

JAVA_PKG_IUSE="doc source test"
WANT_ANT_TASKS="ant-junit"

inherit java-pkg-2 java-ant-2

MY_PV="${PV/_/}"
DESCRIPTION="Tool for repackaging third-party jars."
SRC_URI="http://jarjar.googlecode.com/files/${PN}-src-${MY_PV}.zip"
HOMEPAGE="http://code.google.com/p/jarjar/"
LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-java/asm:3"
RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.4
	dev-java/ant-core
	test? ( dev-java/junit:4 )
	${CDEPEND}"
S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-fix-recursive-jarjar-task.patch"

	# get rid of the Maven plugin, for now...
	rm src/main/com/tonicsystems/jarjar/JarJarMojo.java || die

	pushd lib > /dev/null
		rm *.jar || die
		java-pkg_jar-from --build-only ant-core
		java-pkg_jar-from asm-3
		use test && java-pkg_jar-from --build-only junit-4
	popd > /dev/null
}

src_test() {
	eant junit
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	java-pkg_register-ant-task
	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src/main/*
}

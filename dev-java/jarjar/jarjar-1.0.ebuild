# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Tool for repackaging third-party jars."
HOMEPAGE="http://code.google.com/p/jarjar/"
# There are no changes from 1.0rc8 to 1.0
SRC_URI="http://${PN}.googlecode.com/files/${PN}-src-${PV}rc8.zip"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEP="dev-java/ant-core:0"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip:0
	dev-java/asm:3
	dev-java/maven-plugin-api:2.1
	test? (
		dev-java/junit:0
		dev-java/ant-junit:0
	)
	${COMMON_DEP}"

S="${WORKDIR}/${P}rc8"

java_prepare() {
	cd lib/ && rm * || die
	java-pkg_jar-from ant-core
	java-pkg_jar-from --build-only asm-3 asm.jar asm-3.1.jar
	java-pkg_jar-from --build-only asm-3 asm-commons.jar asm-commons-3.1.jar
	java-pkg_jar-from --build-only maven-plugin-api-2.1
	use test && java-pkg_jar-from --build-only junit
}

src_test() {
	ANT_TASKS="ant-junit" eant test
}

src_install() {
	java-pkg_newjar "dist/${PN}-snapshot.jar" "${PN}.jar"
	java-pkg_register-ant-task
	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src/main/com
}

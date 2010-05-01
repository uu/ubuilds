# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

JAVA_PKG_BSFIX_NAME="maven-build.xml"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A library that allows the parameter names of methods to be accessed at runtime."
HOMEPAGE="http://paranamer.codehaus.org/"
#TODO mirror this before it goes into tree
SRC_URI="http://dev.gentoo.org/~ali_bush/distfiles/paranamer-1.1.7.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

COMMON_DEP="dev-java/asm:3
	dev-java/jmock:1.0
	dev-java/qdox:1.6"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"

src_prepare() {
	sed -i -e '/maven-plugin/d' maven-build.xml || die
	mkdir -p lib || die

	mkdir -p "lib/asm/asm/3.0" || die
	java-pkg_jar-from --into lib/asm/asm/3.0 asm-3 asm.jar asm-3.0.jar

	mkdir -p "lib/jmock/jmock/1.0.0" || die
	java-pkg_jar-from --into lib/jmock/jmock/1.0.0 jmock-1.0 jmock.jar \
		jmock-1.0.0.jar
	mkdir -p "lib/com/thoughtworks/qdox/qdox/1.7" || die
	java-pkg_jar-from --into lib/com/thoughtworks/qdox/qdox/1.7 qdox-1.6 \
		qdox.jar qdox-1.7.jar
	mkdir -p "lib/ant/ant/1.6.5" || die
	java-pkg_jar-from --into lib/ant/ant/1.6.5 --build-only ant-core \
		ant.jar ant-1.6.5.jar

	mkdir -p "lib/com/thoughtworks/${PN}/${PN}-generator/${PV}"
	ln -s "${S}/${PN}-generator/target/${PN}-generator-${PV}.jar" \
		"lib/com/thoughtworks/${PN}/${PN}-generator/${PV}/${PN}-generator-${PV}.jar" \
		|| die
	java-pkg-2_src_prepare
}

EANT_BUILD_TARGET="package"
EANT_DOC_TARGET="javadoc"
EANT_EXTRA_ARGS="-Dmaven.repo.local=${S}/lib -Dmaven.test.skip=true"

src_install() {
	java-pkg_newjar ${PN}/target/${P}.jar "${PN}.jar"
	java-pkg_newjar ${PN}-ant/target/${PN}-ant-${PV}.jar ${PN}-ant.jar
	java-pkg_newjar ${PN}-generator/target/${PN}-generator-${PV}.jar \
		${PN}-generator.jar
	use doc && java-pkg_dojavadoc ${PN}/target/site/apidocs
	use source && java-pkg_dosrc */src/java
}

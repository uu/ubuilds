# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Dependency management utility for jar files."
HOMEPAGE="http://www.kirkk.com/main/Main/JarAnalyzer/"
SRC_URI="http://www.kirkk.com/main/zip/JarAnalyzer-src-${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEP="dev-java/ant-core:0
	dev-java/bcel:0"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip:0
	test? ( dev-java/junit:4 dev-java/ant-junit4:0 )
	${COMMON_DEP}"

S="${WORKDIR}"

java_prepare() {
	einfo "Removing shipped class files and jar archieves:"
	find . -name \*.class -delete -print || die
	find . -name \*.jar -delete -print || die

	# copy default filter rules to pack them with the jar
	# maybe this should go into /etc
	mkdir -p target/classes && mv lib/com target/classes/ || die

	cp "${FILESDIR}/build.xml" . || die

	cd lib/ || die
	java-pkg_jar-from ant-core ant.jar
	java-pkg_jar-from bcel
	use test && java-pkg_jar-from --build-only junit-4
}

src_test() {
	ANT_TASKS="ant-junit4" eant test
}

src_install() {
	java-pkg_dojar "target/${PN}.jar"
	java-pkg_dolauncher jaranalyzer-run-xml --main com.kirkk.analyzer.textui.XMLUISummary
	java-pkg_dolauncher jaranalyzer-run-dot --main com.kirkk.analyzer.textui.DOTSummary

	use doc && java-pkg_dojavadoc target/javadocs
	use source && java-pkg_dosrc src/com
}

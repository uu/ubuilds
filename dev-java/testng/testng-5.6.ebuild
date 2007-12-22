# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source doc"
inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="TestNG is a testing framework inspired from JUnit and NUnit"
HOMEPAGE="http://testng.org/"
SRC_URI="http://testng.org/${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

CDEPEND="dev-java/bsh
		java-virtuals/javadoc
		<dev-java/junit-4
		dev-java/qdox"

DEPEND=">=virtual/jdk-1.5
		dev-java/ant
		app-arch/unzip
		dev-java/ant-core
		${CDEPEND}"
RDEPEND=">=virtual/jre-1.5
		${CDEPEND}"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/testng-build-${PV}.diff"

	find . -iname '*.jar' | xargs rm -fv
	# 1.4 packages
	# backport-util-concurrent-2.2.jar

	java-pkg_jar-from --into 3rdparty --virtual javadoc tools.jar
	java-pkg_jar-from --into 3rdparty --build-only ant-core ant.jar
	java-pkg_jar-from --into 3rdparty junit junit.jar
	java-pkg_jar-from --into 3rdparty bsh bsh.jar
	java-pkg_jar-from --into 3rdparty qdox-1.6 qdox.jar
}

src_compile() {
	ANT_TASKS="none" eant dist-15 $(use_doc javadocs)
}

src_install() {
	java-pkg_newjar "${P}-jdk15.jar" "${PN}.jar"

	use doc && java-pkg_dojavadoc javadocs/
	use source && java-pkg_dosrc src/jdk15/org/testng/
}

src_test() {
	eant test-15
}

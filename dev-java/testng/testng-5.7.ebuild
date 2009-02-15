# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="TestNG is a testing framework inspired from JUnit and NUnit"
HOMEPAGE="http://testng.org/"
SRC_URI="http://testng.org/${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

CDEPEND="dev-java/bsh:0
		java-virtuals/javadoc
		dev-java/junit:0
		dev-java/qdox:1.6
		dev-java/ant-core:0"

DEPEND=">=virtual/jdk-1.5
		app-arch/unzip
		${CDEPEND}"
RDEPEND=">=virtual/jre-1.5
		${CDEPEND}"

QDOX_NAME="qdox-1.6.1.jar"
BSH_NAME="bsh-2.0b4.jar"

src_unpack() {
	default

	find . -iname '*.jar' -exec rm -v {} +

	# Creaty empty jars to fool the unpacking
	cd "${S}/3rdparty" || die
	touch empty
	jar cf ${QDOX_NAME} empty
	jar cf ${BSH_NAME} empty
}

JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_CLASSPATH_TAGS="javac testng"

EANT_GENTOO_CLASSPATH="bsh,qdox-1.6,ant-core,junit,javadoc"
EANT_BUILD_TARGET="dist-15"
EANT_DOC_TARGET="javadocs"

src_install() {
	java-pkg_newjar "${P}-jdk15.jar" "${PN}.jar"
	java-pkg_register-ant-task

	use doc && java-pkg_dojavadoc javadocs/
	use source && java-pkg_dosrc src/jdk15/org/testng/
}

src_test() {
	eant -f test/build.xml run
}

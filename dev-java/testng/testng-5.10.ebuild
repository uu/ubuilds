# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="TestNG is a testing framework inspired from JUnit and NUnit"
HOMEPAGE="http://testng.org/"
SRC_URI="http://testng.org/${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

CDEPEND="dev-java/bsh
		dev-java/ant-core
		dev-java/qdox:1.6
		dev-java/junit:0
		java-virtuals/javadoc"
DEPEND=">=virtual/jdk-1.5
		app-arch/unzip
		${CDEPEND}"
RDEPEND=">=virtual/jre-1.5
		${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH=1
JAVA_ANT_CLASSPATH_TAGS+=" testng"

EANT_GENTOO_CLASSPATH="bsh,ant-core,qdox-1.6,junit,javadoc"
EANT_BUILD_TARGET="dist-15"
EANT_DOC_TARGET="javadocs"

EANT_TEST_TARGET="test-15"

java_prepare() {
	find . -iname '*.jar' -exec rm -v {} +

	# delete unneccesary DTDDoc taskdef
	sed -i.notaskdef -r -e '/<taskdef/{ N;/<taskdef.*\n.*\>/d }' build.xml

	# patch to fix concurrency-related unit test failures (reported upstream as
	# issue 66)
	epatch "${FILESDIR}/testng-5.10-unit_test_concurrency_fix.patch"

	# remove calls extract third party jars
	sed -i.noextract -r \
		-e '/<antcall target="extract-(beanshell|qdox)-jar" \/>/d' \
		build.xml
}

src_test() {
	# first build all the test classes
	eant -f test/build.xml compile

	# In order to ensure the Jar tests will succeed, the following XML and JAR
	# files should be added/created
	jar=`java-config-2 -j`
	cp "${FILESDIR}/testng.xml" "${FILESDIR}/testng-override.xml" test/src/test/jar
	${jar} cf test/src/test/jar/withtestngxml.jar \
		-C test/build test/jar/A.class \
		-C test/build test/jar/B.class \
		-C test/src/test/jar testng.xml
	${jar} cf test/src/test/jar/withouttestngxml.jar \
		-C test/build test/jar/A.class \
		-C test/build test/jar/B.class

	# finally, run the tests
	eant -f test/build.xml run
}

src_install() {
	java-pkg_newjar "${P}-jdk15.jar" "${PN}.jar"
	java-pkg_dolauncher testng --jar "${PN}.jar"
	java-pkg_register-ant-task

	use doc && java-pkg_dojavadoc javadocs/
	use source && java-pkg_dosrc src/jdk15/org/ src/main/org/ src/main/com/
	use examples && java-pkg_doexamples examples/
}

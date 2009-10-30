# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/junit/junit-4.6.ebuild,v 1.4 2009/07/19 14:14:14 nixnut Exp $

# WARNING: JUNIT.JAR IS _NOT_ SYMLINKED TO ANT-CORE LIB FOLDER AS JUNIT3 IS

EAPI="2"
JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

MY_P=${P/-/}
DESCRIPTION="Simple framework to write repeatable tests"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"
HOMEPAGE="http://www.junit.org/"
LICENSE="CPL-1.0"
SLOT="4"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE=""

CDEPEND="dev-java/hamcrest-core:0"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.5
	userland_GNU? ( >=sys-apps/findutils-4.3 )
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

#JAVA_ANT_REWRITE_CLASSPATH=1
#EANT_GENTOO_CLASSPATH="hamcrest-core"
EANT_BUILD_TARGET="jars"

src_unpack() {
	default

	# Unpack source JAR
	mkdir -p "${S}/src/main/java" "${S}/src/test/java" \
		|| die "Unable to create source directories"
	pushd "${S}/src/main/java" >/dev/null
	jar xf "${S}/${P}-src.jar" || die "Unable to unpack sources."
	popd >/dev/null

	# copy Gentoo manifest to working directory
	cp "${FILESDIR}/gentoo-manifest.mf" "${S}"
}

java_prepare() {
	# fix javadoc compilation
	if use doc ; then
		cp "${S}"/javadoc/stylesheet.css "${S}" \
			|| die "Unable to copy Javdoc stylesheet"
	fi

	# remove binary and other generated files
	rm -rf "${rmopt}" javadoc temp.hamcrest.source *.jar \
		|| die "Unable to clean generated files."
	find . -name "*.class" -delete \
		|| die "Unable to remove distributed class files"

	# Let Ant know where its hamcrest went
	EANT_EXTRA_ARGS="-Dhamcrestlib=$(java-pkg_getjars hamcrest-core)"

	# Add Gentoo manifest information to generated JAR files
	java-ant_xml-rewrite -f build.xml -c \
		-e jar -a manifest -v "gentoo-manifest.mf"
}

src_test() {
	mkdir classes || die "Unable to create build directory for tests"
	local cp=$(java-pkg_getjars hamcrest-core):${S}/${PN}${PV}/${PN}-dep-${PV}.jar
	ejavac -classpath ${cp} -d classes $(find junit/tests -name "*.java")

	java -classpath ${cp}:classes org.junit.runner.JUnitCore junit.tests.AllTests \
		|| "Tests failed."
}

src_install() {
	java-pkg_newjar ${PN}${PV}/${PN}-dep-${PV}.jar
	dodoc README.html doc/ReleaseNotes${PV}.txt || die

	use examples && java-pkg_doexamples org/junit/samples
	use source && java-pkg_dosrc src/main/java/org src/main/java/junit

	if use doc; then
		dohtml -r doc/* || die
		java-pkg_dojavadoc ${PN}${PV}/javadoc
	fi
}

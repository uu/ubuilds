# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="doc examples source"

inherit java-utils-2 java-pkg-2

DESCRIPTION="Data mapper framework"
HOMEPAGE="http://ibatis.apache.org/index.html"
SRC_URI="mirror://apache/${PN}/binaries/${PN}.java/${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEP="dev-java/cglib:2
	dev-java/commons-dbcp:0
	dev-java/commons-logging:0
	dev-java/jta:0
	dev-java/log4j:0
	dev-java/oscache:0"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND="dev-java/sun-jdk:1.5
	app-arch/unzip:0
	${COMMON_DEP}"

S="${WORKDIR}"

java_prepare() {
	cd "${S}/src/"
	unzip -q "ibatis-src.zip" || die # That's not a joke!

	cd "${S}/lib/" && rm * || die
	java-pkg_jar-from cglib-2 cglib-full.jar
	java-pkg_jar-from commons-dbcp
	java-pkg_jar-from commons-logging commons-logging.jar
	java-pkg_jar-from jta
	java-pkg_jar-from log4j
	java-pkg_jar-from oscache
}

src_compile() {
	GENTOO_VM="sun-jdk-1.5" \
	ejavac -d . -classpath `echo lib/* | sed -e "s/ /:/g"` \
		`find src/ -type f -name \*.java -print0 | xargs --null`
	jar cf ibatis.jar com || die

	use doc && javadoc -quiet -d javadocs -sourcepath src \
		-classpath `echo lib/* | sed -e "s/ /:/g"` \
		-subpackages com.ibatis.common
}

src_install() {
	java-pkg_dojar "${PN}.jar"
	dodoc release.txt

	use doc && java-pkg_dojavadoc javadocs
	use examples && java-pkg_doexamples simple_example
	use source && java-pkg_dosrc src/com
}

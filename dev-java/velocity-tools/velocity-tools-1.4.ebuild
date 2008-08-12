# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

# no doc or test USE because this package is so old we don't have the req'd deps :-/
JAVA_PKG_IUSE="source"
EANT_DOC_TARGET="docs"
EANT_BUILD_TARGET="jar jar.generic jar.struts jar.view"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A collection of Velocity subprojects with a common goal of creating tools and infrastructure for building both web and non-web applications using the Velocity template engine."
HOMEPAGE="http://jakarta.apache.org/velocity/tools/"
SRC_URI="http://archive.apache.org/dist/jakarta/${PN}/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
S="${WORKDIR}/${P}-src"

CDEPEND="dev-java/antlr:0
	dev-java/commons-beanutils:1.7
	dev-java/commons-chain:1.1
	dev-java/commons-collections
	dev-java/commons-digester
	dev-java/commons-lang:2.1
	dev-java/commons-logging
	=dev-java/commons-validator-1.3*
	dev-java/dvsl
	dev-java/jakarta-oro:2.0
	dev-java/servletapi:2.3
	dev-java/struts-sslext:1.1
	dev-java/struts:1.3
	dev-java/velocity"
DEPEND=">=virtual/jdk-1.4
	${CDEPEND}"
#	doc? ( dev-java/dom4j:1 )
#	test? ( dev-java/junit:4 )
RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}_bypass-download-jars.patch"

	pushd lib > /dev/null
		java-pkg_jar-from antlr
		java-pkg_jar-from commons-beanutils-1.7
		java-pkg_jar-from commons-chain-1.1
		java-pkg_jar-from commons-collections
		java-pkg_jar-from commons-digester
		java-pkg_jar-from commons-lang-2.1
		java-pkg_jar-from commons-logging
		java-pkg_jar-from commons-validator
		java-pkg_jar-from dvsl
		java-pkg_jar-from jakarta-oro-2.0
		java-pkg_jar-from servletapi-2.3
		java-pkg_jar-from struts-sslext-1.1
		java-pkg_jar-from struts-1.3
		java-pkg_jar-from velocity

#
# not sure why docs.classpath isn't picking up dsvl.jar - odd; temporarily disable doc
#
#		if [ use doc ] ; then
#			java-pkg_jar-from --build-only dom4j-1
#		fi
#
#		if [ use test ] ; then
#			java-pkg_jar-from --build-only junit-4
#		fi

	popd > /dev/null
}

src_install() {
	cd "${S}"

	java-pkg_newjar dist/${P}.jar ${PN}.jar
	java-pkg_newjar dist/${PN}-generic-${PV}.jar ${PN}-generic.jar
	java-pkg_newjar dist/${PN}-view-${PV}.jar ${PN}-view.jar

	use source && java-pkg_dosrc src/java/*
#	use doc && java-pkg_dojavadoc "${S}/docs/javadoc"
}

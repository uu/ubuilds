# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jaxme/jaxme-0.3.1-r4.ebuild,v 1.2 2007/10/22 10:13:21 betelgeuse Exp $

JAVA_PKG_IUSE="doc source"
#WANT_ANT_TASKS="ant-antlr"

inherit java-pkg-2 java-ant-2 eutils

MY_PN=ws-${PN}
MY_P=${MY_PN}-${PV}
DESCRIPTION="JaxMe 2 is an open source implementation of JAXB, the specification for Java/XML binding."
HOMEPAGE="http://ws.apache.org/jaxme/index.html"
SRC_URI="mirror://apache/ws/${PN}/source/${MY_P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

COMMON_DEP="
	>=dev-java/xerces-2.7
	dev-java/junit
	dev-java/gnu-crypto
	>=dev-java/log4j-1.2.8
	dev-java/ant-core
	dev-java/xmldb
	dev-java/antlr:0"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
# FIXME doesn't like to compile with Java 1.6
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"

S="${WORKDIR}/${MY_P}"

# We do it later
JAVA_PKG_BSFIX="off"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}"/${P}.patch

	java-pkg_filter-compiler jikes
	rm -v src/documentation/lib/*.jar || die
	cd "${S}/prerequisites"
	rm -v *.jar || die
	java-pkg_jarfrom junit
	java-pkg_jarfrom log4j log4j.jar log4j-1.2.8.jar
	java-pkg_jarfrom gnu-crypto gnu-crypto.jar
	java-pkg_jarfrom xerces-2
	java-pkg_jarfrom xmldb xmldb-api.jar xmldb-api-20021118.jar
	java-pkg_jarfrom xmldb xmldb-api-sdk.jar xmldb-api-sdk-20021118.jar

	# Bad build system, should be fixed to use properties
	java-pkg_jarfrom ant-core ant.jar ant-1.5.4.jar
	java-pkg_jarfrom ant-core ant.jar ant.jar
	java-pkg_jarfrom antlr antlr.jar

	# Special case: jaxme uses build<foo>.xml files, so rewriting them by hand
	# is better:
	cd "${S}"
	for i in build*.xml src/webapp/build.xml src/test/jaxb/build.xml; do
		java-ant_bsfix_one "${i}"
	done
}

EANT_EXTRA_ARGS="-Dbuild.apidocs=dist/doc/api"
EANT_BUILD_TARGET="API.jar XS.jar JS.jar JM.compile PM.compile"

src_install() {
	for i in jaxmeapi jaxme2-rt jaxmepm; do
		java-pkg_newjar dist/${i}-${PV}.jar ${i}.jar
	done
	
	for i in jaxmexs jaxmejs; do
		java-pkg_newjar --virtual dist/${i}-${PV}.jar ${i}.jar
	done
	
	#Compatibility symlink for jaxb
	dosym jaxmeapi.jar /usr/share/${PN}/lib/jaxb-api.jar || die "dosym jaxmeapi.jar failed"
	java-pkg_regjar --virtual /usr/share/${PN}/lib/jaxb-api.jar
	
	dosym jaxme2-rt.jar /usr/share/${PN}/lib/jaxb-impl.jar || die "dosym jaxme2-rt.jar failed"
	java-pkg_regjar --virtual /usr/share/${PN}/lib/jaxb-impl.jar


	dodoc NOTICE || die

	if use doc; then
		java-pkg_dojavadoc dist/doc/api
		java-pkg_dohtml src/documentation/manual
	fi
	use source && java-pkg_dosrc src/*/*
}

# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A text-processing Java classes that serialize objects to XML and back again."
HOMEPAGE="http://xstream.codehaus.org/index.html"
SRC_URI="http://repository.codehaus.org/com/thoughtworks/${PN}/${PN}-distribution/${PV}/${PN}-distribution-${PV}-src.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"

IUSE=""

COMMON_DEPS="
	dev-java/cglib:2.1
	dev-java/dom4j:1
	dev-java/jdom:1.0
	dev-java/joda-time:0
	dev-java/xom:0
	dev-java/xpp3:0
	dev-java/xml-commons-external:1.3
	dev-java/jettison:0
	java-virtuals/stax-api
	test? (
		dev-java/junit
		dev-java/xml-writer
		dev-java/commons-lang:2.1
		dev-java/jmock:1.0
		dev-java/jakarta-oro:2.0
		dev-java/stax
		dev-java/xml-writer
		dev-java/wstx:3.2
	)"

DEPEND=">=virtual/jdk-1.5
	${COMMON_DEPS}"
RDEPEND=">=virtual/jre-1.5
	app-arch/unzip
	${COMMON_DEPS}"

S="${WORKDIR}/${P}/${PN}"

JAVA_ANT_REWRITE_CLASSPATH="true"

src_unpack() {
	unpack ${A}
	cd "${S}/lib"
	rm -v *.jar || die
	rm -rf jdk1.3 || die
}

EANT_GENTOO_CLASSPATH="xpp3,jdom-1.0,xom,dom4j-1,joda-time,cglib-2.1
xml-commons-external-1.3,jettison,stax-api,junit,commons-lang-2.1,jmock-1.0,jakarta-oro-2.0,stax,xml-writer,wstx-3.2"

EANT_BUILD_TARGET="benchmark:compile jar test:compile"
EANT_EXTRA_ARGS="-Dversion=${PV}"

src_test(){
	ANT_TASKS="ant-junit ant-trax"
	eant test || die "Tests failed"
}

src_install(){
	java-pkg_newjar target/${P}.jar
	java-pkg_newjar target/${PN}-benchmark-${PV}.jar ${PN}-benchmark.jar

	use doc && java-pkg_dojavadoc target/javadoc
	use source && java-pkg_dosrc src/java/com
}

pkg_postinst(){
	elog "Major Changes from 1.2 See:"
	elog "http://xstream.codehaus.org/changes.html"
	elog "to prevent breakage ..."
}

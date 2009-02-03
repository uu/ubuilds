# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A text-processing Java classes that serialize objects to XML and back again."
HOMEPAGE="http://xstream.codehaus.org/index.html"
SRC_URI="http://repository.codehaus.org/com/thoughtworks/${PN}/${PN}-distribution/${PV}/${PN}-distribution-${PV}-src.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

#jettison only in java-experimental
COMMON_DEPS="
	dev-java/commons-lang:2.1
	dev-java/cglib:2.1
	dev-java/dom4j:1
	dev-java/jsr173
	dev-java/jdom:1.0
	dev-java/joda-time
	dev-java/xom
	dev-java/xpp3
	dev-java/xml-commons-external:1.3
	dev-java/jettison"

DEPEND=">=virtual/jdk-1.5
	${COMMON_DEPS}"
RDEPEND=">=virtual/jre-1.5
	app-arch/unzip
	${COMMON_DEPS}"

S="${WORKDIR}/${P}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}/lib"
	rm -v *.jar || die
	rm -rf jdk1.3 || die

	java-pkg_jar-from xpp3
	java-pkg_jar-from jdom-1.0
	java-pkg_jar-from xom
	java-pkg_jar-from dom4j-1
	java-pkg_jar-from joda-time
	java-pkg_jar-from cglib-2.1
	java-pkg_jar-from xml-commons-external-1.3
	java-pkg_jar-from jettison
	java-pkg_jar-from --build-only ant-core
}

EANT_BUILD_TARGET="benchmark:compile jar"
EANT_EXTRA_ARGS="-Dversion=${PV}"

src_install(){
	java-pkg_newjar target/${P}.jar
	java-pkg_newjar target/${PN}-benchmark-${PV}.jar ${PN}-benchmark.jar

	use doc && java-pkg_dojavadoc target/javadoc
	use source && java-pkg_dosrc src/java/com
}

pkg_postinst(){
	elog "Major Changes from previous version in Portage"
	elog "See:"
	elog "http://xstream.codehaus.org/changes.html"
	elog "to prevent breakage ..."
}

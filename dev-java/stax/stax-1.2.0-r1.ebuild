# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A standard XML processing API that allows you to stream XML data from and to your application."
HOMEPAGE="http://stax.codehaus.org/"
SRC_URI="http://dist.codehaus.org/${PN}/distributions/${PN}-src-${PV}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

CDEPEND="=dev-java/dtdparser-1.21*
	java-virtuals/jaxp-virtual"

RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${CDEPEND}"

S="${WORKDIR}"

EANT_BUILD_TARGET="ri_bin_dist"
EANT_GENTOO_CLASSPATH="dtdparser-1.21,jaxp-virtual"

src_unpack() {
	unpack ${A}
	rm -rfv src/javax/xml/namespace #Part of >=JAXP-1.3.
	rm -rfv src/com/wutka #Bundled lib.
	java-ant_rewrite-classpath
}

src_install() {
	java-pkg_newjar build/stax-api-1.0.1.jar stax-api.jar
	java-pkg_newjar build/stax-${PV}-dev.jar stax-impl.jar

	if use doc; then
		java-pkg_dojavadoc "${S}/build/javadoc"
	fi
	use source && java-pkg_dosrc src/javax src/com
	use examples && java-pkg_doexamples src/samples
}

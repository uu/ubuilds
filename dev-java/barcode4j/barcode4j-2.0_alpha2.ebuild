# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source" # doc fails

inherit java-pkg-2 java-ant-2

DESCRIPTION="Barcode4J is a flexible generator for barcodes written in Java"
HOMEPAGE="http://barcode4j.sourceforge.net/"
MY_P=${P//_}
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
COMMON_DEPEND="
	>=dev-java/avalon-framework-4.2.0
	>=dev-java/commons-cli-1.0
	>=dev-java/jdom-1.0
	>=dev-java/xalan-serializer-2.7.0
	=java-virtuals/servlet-api-2.2
	>=dev-java/xalan-2.7.0
	>=dev-java/xerces-2.9.0
	dev-java/jaxp"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEPEND}
	test? ( dev-java/ant-junit )"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"

IUSE="examples"

# tests fail
#IUSE="examples test"
RESTRICT="test"

# build.xml already contains source and target
JAVA_PKG_BSFIX="off"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack "${A}"
	cd "${S}"

	# Use system jars
	cd lib
	rm -f *
	java-pkg_jarfrom avalon-framework-4.2,commons-cli-1,jdom-1.0,xalan-serializer,servlet-api-2.2,xalan,xerces-2,jaxp
	cd ..
}

src_compile() {
	# Note that package depends on compile so it is sufficient to run
	# just package
	eant package # docs fail $(use_doc javadocs)
}

# Please note that currently tests fail.
src_test() {
	true #ANT_TASKS="ant-junit" eant test
}

src_install() {
	java-pkg_dojar build/${PN}.jar
	java-pkg_dojar build/${PN}-light.jar
	dodoc README.txt
	use examples && java-pkg_doexamples examples
	# docs fail
	#use doc && java-pkg_dojavadoc build/javadocs
	use source && java-pkg_dosrc src/{java,java-1.4}/org
}

# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xerces/xerces-2.8.1.ebuild,v 1.5 2007/02/12 04:57:27 nichoj Exp $

JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-nodeps"
inherit java-pkg-2 java-ant-2

MY_PN="PDFBox"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Java library for working with PDF documents"
HOMEPAGE="http://www.pdfbox.org"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

CDEPEND="dev-java/fontbox
	>=dev-java/bcprov-1.32
	>=dev-java/bcmail-1.32
	=dev-java/lucene-2*
	dev-java/ant-core"
RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	rm -v external/*.jar
	rm -rf docs/javadoc
	rm -rf src/test

	cd external
	java-pkg_jar-from fontbox
	java-pkg_jar-from bcprov
	java-pkg_jar-from bcmail
	java-pkg_jar-from lucene-2
	java-pkg_jar-from ant-core ant.jar
}

EANT_BUILD_TARGET="package"

src_install() {
	java-pkg_newjar lib/${MY_P}.jar

	if use doc; then
		dohtml -r docs/*
		java-pkg_dojavadoc website/build/site/javadoc
	fi

	use source && java-pkg_dosrc src/org
}

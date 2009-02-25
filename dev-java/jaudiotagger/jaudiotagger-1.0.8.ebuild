# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source test"
inherit java-pkg-2 java-ant-2

MY_P="${PN}v${PV}"

DESCRIPTION="Java library for editing tag information in audio files"
HOMEPAGE="http://${PN}.dev.java.net/"
SRC_URI="https://jaudiotagger.dev.java.net/files/documents/2750/78029/${MY_P}.zip"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND=">=virtual/jdk-1.5
	test?
	(
		dev-java/junit
		dev-java/ant-junit
		dev-java/ant-trax
	)"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${MY_P}"
EANT_BUILD_TARGET="build.jar"
EANT_DOC_TARGET="build.dev.javadoc"

src_unpack() {
	unpack "${A}"
	cd "${S}" || die
	rm -rfv lib/* dist/* || die
	use test && java-pkg_jar-from --build-only --into lib junit
	epatch ${FILESDIR}/${P}-buildfixes.patch
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	use doc && java-pkg_dojavadoc www/devjavadoc
	use source && java-pkg_dosrc src/org
}

src_test() {
	ANT_TASKS="ant-junit ant-trax" eant run.tests
}

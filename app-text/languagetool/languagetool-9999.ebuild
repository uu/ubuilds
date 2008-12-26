# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2 cvs

DESCRIPTION="An Open Source language checker for English, German, Polish, Dutch, and other languages."
HOMEPAGE="http://www.languagetool.org/"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

#RESTRICT="test" #Tests fail.

COMMON_DEPEND="dev-java/jdictrayapi:0
	dev-java/jaminid:0
	dev-java/morfologik-stemming:0
	=dev-java/jwordsplitter-9999:0"

DEPEND=">=virtual/jdk-1.5
	test?
	(
		dev-java/ant-junit:0
	)
	${COMMON_DEPEND}"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"

ECVS_SERVER="languagetool.cvs.sourceforge.net:/cvsroot/languagetool"
ECVS_MODULE="JLanguageTool"
S="${WORKDIR}/${ECVS_MODULE}"

EANT_GENTOO_CLASSPATH="jdictrayapi,jaminid,morfologik-stemming,jwordsplitter"
EANT_BUILD_TARGET="init build"

src_unpack() {
	cvs_src_unpack
	cd "${S}" || die
	ebegin "Deleting unnecessary files"
	rm -rf libs/* docs openoffice tests website
	rm -rf src/java/de/danielnaber/languagetool/openoffice
	eend
	epatch "${FILESDIR}"/${PN}-0.9.3-build.xml.patch
	cd libs || die
	java-pkg_jar-from jdictrayapi
	java-pkg_jar-from jaminid
	java-pkg_jar-from morfologik-stemming morfologik-stemming-nodict.jar morfologik-stemming-nodict-1.1.jar
	java-pkg_jar-from jwordsplitter
}

src_test() {
	java-pkg_jar-from --into build junit
	ANT_TASKS="ant-junit" eant test
}

src_install() {
	java-pkg_dojar dist/LanguageTool.jar
	java-pkg_dojar dist/LanguageToolGUI.jar

	java-pkg_dolauncher ${PN} --main de.danielnaber.languagetool.Main
	java-pkg_dolauncher ${PN}-gui --main de.danielnaber.languagetool.gui.Main

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/de
	dodoc {README,CHANGES}.txt
	insinto /usr/share/languagetool
	doins -r src/{rules,resource} || die
}

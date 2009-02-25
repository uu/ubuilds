# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source test"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="HTML Parser is a Java library used to parse HTML in either a linear or nested fashion"
HOMEPAGE="http://htmlparser.sourceforge.net/"
SRC_URI="mirror://sourceforge/htmlparser/htmlparser1_6_20090610.zip"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

S="${WORKDIR}/htmlparser1_6/"

RDEPEND=">=virtual/jre-1.5"

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	test? ( dev-java/junit )"

RESTRICT="test"

src_unpack() {
	unpack "${A}"
	cd "${S}" || die
	unzip -q src.zip || die
	rm -rf docs bin lib/* src.zip
	mkdir -p src_test/org/htmlparser/tests || die
	mv src/org/htmlparser/tests src_test/org/htmlparser/tests || die
	epatch "${FILESDIR}/buildfixes.patch"
	if use test; then
		cd "lib/" die
		java-pkg_jarfrom --build-only junit
		cd "../src_test" || die
		find . -name '*.java' -exec sed -i -e \
			"s:http\://htmlparser.sourceforge.net/javadoc_1_3/:http\://htmlparser.sourceforge.net/javadoc/:g" '{}' \;
	fi
	ln -s `java-config -t`
}

src_compile() {
	eant jar thumbelina filterbuilder $(use_doc)
}

src_install() {
	java-pkg_dojar lib/*.jar
	use doc && java-pkg_dojavadoc docs/javadoc
	use source && java-pkg_dosrc src/org
	java-pkg_dolauncher beanbaby --main org.htmlparser.beans.BeanyBaby
	java-pkg_dolauncher filterbuilder --main org.htmlparser.parserapplications.filterbuilder.FilterBuilder
	java-pkg_dolauncher lexer --main org.htmlparser.lexer.Lexer
	java-pkg_dolauncher linkextractor --main org.htmlparser.parserapplications.LinkExtractor
	java-pkg_dolauncher parser --main org.htmlparser.Parser
	java-pkg_dolauncher sitecapturer --main org.htmlparser.parserapplications.SiteCapturer
	java-pkg_dolauncher stringextractor --main org.htmlparser.parserapplications.StringExtractor
	java-pkg_dolauncher thumbelina --main org.htmlparser.lexerapplications.thumbelina.Thumbelina
	java-pkg_dolauncher translate --main org.htmlparser.util.Translate
	dodoc *.txt
}

src_test() {
	eant test
}

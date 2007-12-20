# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

JAVA_PKG_IUSE=""

inherit java-pkg-2 java-ant-2 java-osgi

DESCRIPTION="ICU4J is a mature, widely used set of Java libraries providing Unicode and Globalization support for software applications."
MY_PV=${PV//./_}

SRC_URI="http://download.icu-project.org/files/${PN}/${PV}/${PN}src_${MY_PV}.jar
	doc? ( http://download.icu-project.org/files/${PN}/${PV}/${PN}docs_${MY_PV}.jar)"

HOMEPAGE="http://www.icu-project.org/"
LICENSE="icu"
SLOT="3.6"
KEYWORDS="~x86 ~amd64"

RDEPEND=">=virtual/jre-1.4"

DEPEND=">=virtual/jdk-1.4"

IUSE="doc source"

S="${WORKDIR}"

src_unpack() {
	jar -xf "${DISTDIR}/${PN}src_${MY_PV}.jar" || die "Failed to unpack"

	rm "src/com/ibm/icu/dev/data/testdata.jar"
	#rm "src/com/ibm/icu/impl/data/icudata.jar"
	
	if use doc; then
		mkdir docs; cd docs
		jar -xf "${DISTDIR}/${PN}docs_${MY_PV}.jar" || die "Failed to unpack docs"
	fi
}

src_compile() {
	eant jar
}

src_install() {
	java-osgi_newjar-fromfile "${PN}.jar" "${FILESDIR}/icu4j-${PV}-manifest" "International Components for Unicode for Java (ICU4J)"
	java-pkg_dojar "${PN}-charsets.jar"
	
	use doc && java-pkg_dohtml -r readme.html docs/*
	use source && java-pkg_dosrc src/*
}

src_test() {
	eant check
}
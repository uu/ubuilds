# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2

DESCRIPTION="i18n from the Excalibur containerkit"
HOMEPAGE="http://excalibur.apache.org/"
SRC_URI="mirror://apache/excalibur/${PN}/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

JAVA_VERSION="1.3"

RDEPEND=">=virtual/jre-${JAVA_VERSION}"

DEPEND=">=virtual/jdk-${JAVA_VERSION}"
SRC_DIR="${S}/src/java"
JAVADOC_DIR="${S}/javadoc"

src_compile() {
	mkdir classes || die "Could not create compile output dir"
	ejavac -d classes $(find src/java -name "*.java") || die "Compilation failed"
	jar -cf "${S}/${PN}.jar" -C classes . || die "Could not create jar"
	#Generate javadoc
	if use doc ; then
		mkdir "${JAVADOC_DIR}" || die "Could not create javadoc dir"
		cd ${SRC_DIR}
		javadoc -source "${JAVA_VERSION}" -d ${JAVADOC_DIR} $(find "org/apache/avalon/excalibur/i18n" -type d | tr '/' '.') || die "Could not create javadoc"
	fi
}

src_install() {
	java-pkg_dojar ${PN}.jar
	dodoc README.txt
	use doc && java-pkg_dojavadoc ${JAVADOC_DIR}
	use source && java-pkg_dosrc src/*
}

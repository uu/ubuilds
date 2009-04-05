# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2

DESCRIPTION="Maven's maven-plugin-api module."
HOMEPAGE="http://maven.apache.org/ref/current/maven-plugin-api/"
SRC_URI="mirror://apache/maven/source/maven-${PV}-src.tar.bz2"

LICENSE="Apache-2.0"
SLOT="2.1"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4"

S="${WORKDIR}/maven-2.0.9-src/${PN}"

src_prepare() {
	find "${WORKDIR}" -name \*.jar -delete || die
}

src_compile() {
	ejavac -d . \
		`find src/main/java -type f -name \*.java -print0 | xargs --null`
	jar cf ${PN}.jar org || die
	use doc && javadoc -quiet -d docs -sourcepath src/main/java \
		-subpackages org.apache.maven.plugin
}

src_install() {
	java-pkg_dojar "${PN}.jar"
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src/main/java/*
}

# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Commons Email aims to provide a API for sending email."
HOMEPAGE="http://commons.apache.org/email/"
SRC_URI="mirror://apache/commons/email/source/${P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
COMMON_DEP="dev-java/sun-jaf
	dev-java/sun-javamail"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"

S=${WORKDIR}/${P}-src
EANT_GENTOO_CLASSPATH="sun-jaf,sun-javamail"
EANT_BUILD_TARGET="package"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e 's:<classpath refid="build.classpath"/>::g' maven-build.xml
	sed -i -e 's:compile,test:compile:g' maven-build.xml
	java-ant_rewrite-classpath maven-build.xml
}

src_install() {
	java-pkg_newjar target/${P}.jar ${PN}.jar
	dodoc *.txt || die
	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/java/*
}

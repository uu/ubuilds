# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source examples"

inherit java-pkg-2 java-ant-2

MY_PN="AppFramework"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Swing Application Framework prototype implementation is a small set of Java classes that simplify building desktop applications."
HOMEPAGE="https://appframework.dev.java.net/"
SRC_URI="https://appframework.dev.java.net/downloads/${MY_P}-src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""

IUSE=""

COMMON_DEP="dev-java/swing-worker"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	java-pkg_jar-from --into lib swing-worker
}

#EANT_BUILD_TARGET=""
#EANT_DOC_TARGET=""

src_install() {
	java-pkg_dojar "${PN}.jar"
	use doc && java-pkg_dojavadoc build/javadoc
	use source && java-pkg_dosrc src/org
	use examples && java-pkg_doexamples src/examples/*
}


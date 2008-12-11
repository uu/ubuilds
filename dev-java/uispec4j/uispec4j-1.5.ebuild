# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"
EAPI="1"

inherit java-pkg-2 java-ant-2

DESCRIPTION="An Open Source functional and/or unit testing library for
Swing-based Java applications"
HOMEPAGE="http://www.uispec4j.org"
SRC_URI="http://www.uispec4j.org/${P}-src.tar.gz"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

COMMON_DEP="dev-java/junit:0
			dev-java/asm:1.5
			java-virtuals/jdk-with-com-sun"

RDEPEND=">=virtual/jre-1.4
		${COMMON_DEP}"
DEPEND="=virtual/jdk-1.4*
		${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	eant init

	java-pkg_jar-from --into target/lib junit junit.jar junit-3.8.1.jar
	java-pkg_jar-from --into target/lib asm-1.5 asm.jar asm-1.5.2.jar
	java-pkg_jar-from --into target/lib asm-1.5 asm-util.jar asm-util-1.5.2.jar
	java-pkg_jar-from --into target/lib asm-1.5 asm-attrs.jar asm-attr-1.5.1.jar
}

#Restrict tests as they depend on having a DISPLAY.
RESTRICT="test"
src_test() {
	ANT_TASKS="ant-junit" eant test
}

src_install() {
	java-pkg_newjar "target/${P}.jar"
	use doc && java-pkg_dojavadoc dist/docs/api/
	use source && java-pkg_dosrc src/java/*
}


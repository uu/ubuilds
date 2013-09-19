# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A JavaScript compressor"
HOMEPAGE=""
SRC_URI="https://github.com/yui/yuicompressor/releases/download/v2.4.8/yuicompressor-2.4.8.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 amd64"

IUSE=""

COMMON_DEP=">=dev-java/jargs-1.0
			>=dev-java/rhino-1.6.7"

RDEPEND=">=virtual/jre-1.4
  ${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
  app-arch/unzip
  ${COMMON_DEP}"

#EANT_BUILD_TARGET="clean build.jar"
EANT_DOC_TARGET=""
#S="${S}/../"

src_unpack() {
	unpack ${A}
	echo ${S}
	mkdir ${S}
	mv ${S}.jar ${S}
}

src_install() {
#cd "${S}../"
	java-pkg_dojar "${P}.jar"
#  use doc && java-pkg_dojavadoc build/javadoc
#  use source && java-pkg_dosrc src
  #java-pkg_dolauncher ${PN} --jar ${S}/${P}.jar
  java-pkg_dolauncher ${PN} --jar /usr/share/yuicompressor/lib/${P}.jar
}

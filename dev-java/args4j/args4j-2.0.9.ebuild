# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java command line options parser"
HOMEPAGE="https://args4j.dev.java.net/"
SRC_URI="https://args4j.dev.java.net/files/documents/977/100439/${P}-src.tar.gz"

LICENSE="BSD-2"
SLOT="2"
KEYWORDS="~x86 ~amd64 ~ia64"

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# This build.xml was first adapted for version 2.0.9, but should
	# apply to later versions as well. No need to change the version
	# number if the build system stayed the same. Please compare the
	# POMs you find at http://download.java.net/maven/1/args4j/poms/
	cp "${FILESDIR}/build-2.0.9.xml" build.xml
}

src_install() {
	java-pkg_dojar target/${PN}.jar
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/*
}

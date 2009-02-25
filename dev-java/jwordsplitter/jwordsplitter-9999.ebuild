# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-ant-2 cvs

DESCRIPTION="jWordSplitter a a small Java library that splits compound words into their parts."
HOMEPAGE="http://sourceforge.net/projects/jwordsplitter/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4"

EANT_BUILD_TARGET="build"

ECVS_SERVER="jwordsplitter.cvs.sourceforge.net:/cvsroot/jwordsplitter"
ECVS_MODULE="jWordSplitter"
S="${WORKDIR}/${ECVS_MODULE}"

src_unpack() {
	cvs_src_unpack
	cd "${S}" || die
	find . -name "*Test.java" -print -delete
	#deleting tests for now.
}

src_install() {
	java-pkg_dojar dist/jWordSplitter.jar
	use source && java-pkg_dosrc src/*
	dodoc README.txt || die
}

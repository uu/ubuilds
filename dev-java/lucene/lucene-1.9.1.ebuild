# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="test source doc"

inherit java-pkg-2 java-ant-2

DESCRIPTION="High-performance, full-featured text search engine written entirely in Java"
HOMEPAGE="http://jakarta.apache.org/lucene"
SRC_URI="mirror://apache/lucene/java/archive/${P}-src.tar.gz"
LICENSE="Apache-1.1"
SLOT="1.9"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86 ~x86-fbsd"
IUSE=""
DEPEND=">=virtual/jdk-1.4
	>=dev-java/ant-core-1.5
	test? ( dev-java/junit dev-java/ant-tasks )"
# anyone know why a jdk?
RDEPEND=">=virtual/jdk-1.4"

src_unpack() {
	unpack ${A}
	cd "${S}/lib"
	rm -f *.jar
	use test && java-pkg_jar-from --build-only junit
}

src_compile() {
	eant jar-core $(use_doc javadocs)
}

src_test() {
	mkdir -p lib
	cd lib
	java-pkg_jar-from --build-only junit
	cd ..
	eant test
}

src_install() {
	dodoc CHANGES.txt README.txt
	# WTF is with the jar version below
	java-pkg_newjar build/lucene-core-1.9.2-dev.jar

	use doc && java-pkg_dojavadoc build/docs/api
	use source && java-pkg_dosrc src/java/org
}

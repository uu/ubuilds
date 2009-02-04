# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Web-page layout and decoration framework"
SRC_URI="https://sitemesh.dev.java.net/files/documents/887/43018/${P}.zip"

HOMEPAGE="http://www.opensymphony.com/sitemesh/"
LICENSE="OpenSymphony-1.1"
SLOT="0"
KEYWORDS=""

CDEPEND=">=dev-java/servletapi-2.4
	dev-java/velocity-tools
	>=dev-java/velocity-1.4
	>=dev-java/freemarker-2.3.10
	=dev-java/tapestry-3*
	>=dev-java/javacup-0.11a_beta20060608
	>=dev-java/freemarker-2.3.10"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.4"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.4
	>=dev-java/jflex-1.4.1
	dev-java/junit"

IUSE=""

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	java-ant_rewrite-classpath
	local sitemesh_classpath="$(java-pkg_getjars --build-only --with-dependencies jflex)"
	java-ant_xml-rewrite -f build.xml --change -e java -a classpath -v "${sitemesh_classpath}" || die

	EPATCH_OPTS="-d ${S}" epatch "${FILESDIR}/${P}-lexer.flex.patch"

	cd "${S}"
	rm -rf lib/
	mkdir lib
}

src_compile() {
	local gentoo_classpath="$(java-pkg_getjars servletapi-2.4,freemarker-2.3,tapestry-3.0,velocity,velocity-tools)"

	ANT_TASKS="javacup" eant -Dgentoo.classpath="${gentoo_classpath}"
	#eant javadocs
}

src_install() {
	java-pkg_newjar "dist/${P}.jar"

	dodoc README.txt CHANGES.txt || die

	use source && java-pkg_dosrc src/java/*

	#src/etc/dtd/sitemesh_1_0_decorators.dtd src/etc/dtd/sitemesh_1_5_decorators.dtd
	#dodoc -r src/etc/dtd/

	# Currently we connot install javadoc as the Ant target does not produce index.html
	#use doc && java-pkg_dojavadoc dist/docs/api
}

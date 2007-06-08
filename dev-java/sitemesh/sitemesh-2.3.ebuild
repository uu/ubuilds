# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Web-page layout and decoration framework"
SRC_URI="https://sitemesh.dev.java.net/files/documents/887/43018/${P}.zip"

#SRC_URI="${P}.tar.bz2"

HOMEPAGE="http://www.opensymphony.com/sitemesh/"
LICENSE="OpenSymphony-1.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RDEPEND=">=virtual/jre-1.4
	>=dev-java/javacup-0.11a_beta20060608
	=dev-java/tapestry-3*
	>=dev-java/freemarker-2.3.10
	>=dev-java/velocity-1.4
	dev-java/velocity-tools
	>=dev-java/servletapi-2.4"

DEPEND=">=virtual/jdk-1.4
	>=dev-java/jflex-1.4.1
	dev-java/junit
	>=dev-java/servletapi-2.4
	=dev-java/tapestry-3*
	>=dev-java/freemarker-2.3.10
	>=dev-java/javacup-0.11a_beta20060608
	>=dev-java/velocity-1.4
	dev-java/velocity-tools"

IUSE="doc source vim-syntax"

S="${WORKDIR}"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	java-ant_rewrite-classpath
	cd "${S}/src/java/com/opensymphony/module/sitemesh/html/tokenizer"
	epatch "${FILESDIR}/${P}-lexer.flex.patch"
	cd "${S}"
	rm -rf lib/
}

src_compile() {

	ANT_TASKS="javacup"

	cd "${S}"
	mkdir lib
	cd lib

	#echo `java-pkg_getjars --build-only --with-dependencies jflex`

	sitemesh_classpath="$(java-pkg_getjars --build-only --with-dependencies jflex)"
	gentoo_classpath="$(java-pkg_getjars servletapi-2.4,freemarker-2.3,tapestry-3.0,velocity,velocity-tools)" 
	
	echo "${gentoo_classpath}"

	cd "${S}"
	java-ant_xml-rewrite -f build.xml --change -e java -a classpath -v "${sitemesh_classpath}" || die

	eant -Dgentoo.classpath="${gentoo_classpath}"
	#eant javadocs
}

src_install() {

	java-pkg_newjar dist/sitemesh-2.3.jar

	dodoc README.txt CHANGES.txt 

	#src/etc/dtd/sitemesh_1_0_decorators.dtd src/etc/dtd/sitemesh_1_5_decorators.dtd
	#dodoc -r src/etc/dtd/

	# Currently we connot install javadoc as the Ant target does not produce index.html
	#use doc && java-pkg_dojavadoc dist/docs/api

}

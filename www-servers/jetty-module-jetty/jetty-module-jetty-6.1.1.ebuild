# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Jetty module of Jetty - Java HTTP Servlet Server"
HOMEPAGE="http://www.mortbay.org/"
SRC_URI="mirror://sourceforge/jetty/jetty-${PV}-src.zip"
LICENSE="Artistic"
SLOT="6"
KEYWORDS="~x86"
IUSE="test"

COMMON_DEPEND="~www-servers/jetty-module-jetty-${PV}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	dev-java/ant-core
	>=dev-java/tomcat-servlet-api-6.0.0
	test? (
		dev-java/ant-tasks
		=dev-java/junit-3.8*
	)
	${COMMON_DEPEND}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"

S="${WORKDIR}/jetty-${PV}/modules/jetty"

src_unpack() {
	unpack "${A}"
	cd ${S}
	cp ${FILESDIR}/${P}-build.xml build.xml
	java-ant_rewrite-classpath
}

src_compile() {
	eant jar -Dgentoo.classpath=$(java-pkg_getjars jetty-module-util,tomcat-servlet-api-2.5)
}

src_test() {
	eant test -Dgentoo.classpath=$(java-pkg_getjars junit)
}

src_install() {
	java-pkg_newjar target/jetty-${PV}.jar jetty.jar
	use source && java-pkg_dosrc src/main/java/org
}

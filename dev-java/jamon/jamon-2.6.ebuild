# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jamon/jamon-1.01-r1.ebuild,v 1.2 2007/04/28 19:15:02 betelgeuse Exp $

inherit java-pkg-2 java-ant-2 eutils

MY_PV="26"
DESCRIPTION="A free, simple, high performance, thread safe, Java API that allows
developers to easily monitor production applications"
HOMEPAGE="http://www.jamonapi.com"
SRC_URI="mirror://sourceforge/jamonapi/${PN}all_${MY_PV}.zip"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=virtual/jre-1.4
	=dev-java/servletapi-2.4*
	dev-java/log4j"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${RDEPEND}"

S="${WORKDIR}/jamonapi"

src_unpack() {
	unpack ${A}
	cd ${S}
	rm ${PN}.war ${P}.jar
	mkdir lib dist
	cd src/ant

	java-ant_rewrite-classpath
	java-ant_xml-rewrite -f build.xml --change -e javadoc -a classpath -v "\${gentoo.classpath}" || die
}

src_compile() {
	cd "${S}/src/ant"
	eant -Dgentoo.classpath="$(java-pkg_getjars servletapi-2.4,log4j)" JAR javadoc
}

src_install() {
	java-pkg_newjar dist/${P}.jar

	use doc && java-pkg_dojavadoc src/doc/javadoc
}

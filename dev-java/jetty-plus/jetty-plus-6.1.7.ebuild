# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $ 

JAVA_MAVEN_BUILD_SYSTEM="eant"
EAPI=1

inherit eutils java-pkg-2 java-ant-2
DESCRIPTION="A Lightweight Servlet Engine API"
SRC_URI="http://ftp.mortbay.org/pub/jetty-${PV}/jetty-${PV}-src.zip"
HOMEPAGE="http://www.mortbay.org/"
KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="Apache-1.1"
SLOT="0"

COMMON_DEP=""

RDEPEND=">=virtual/jre-1.6
    ${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.6
    app-arch/unzip
    ${COMMON_DEP}"
S=jetty-${MY_PV}
src_unpack() {
	unpack ${A}
	cd jetty-${PV} || die cd failed
	epatch ${FILESDIR}/${PV}/build-jetty-plus-${PV}.patch
}


EANT_GENTOO_CLASSPATH=""
EANT_BUILD_TARGET="clean compile package"

src_compile() {
	cd jetty-${PV} 
	eant package
}

src_install() {
	cd jetty-${PV}
	java-pkg_newjar "modules/plus/target/jetty-plus-${PV}.jar" jetty-plus.jar
}

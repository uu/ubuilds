# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $ 

JAVA_MAVEN_BUILD_SYSTEM="eant"
EAPI=1

inherit eutils java-pkg-2 
#java-maven-2 
#java-ant-2
MY_PV=6.1.7
DESCRIPTION="A Lightweight Servlet Engine API"
SRC_URI="http://ftp.mortbay.org/pub/jetty-${MY_PV}/jetty-${MY_PV}-src.zip"
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
#	cd jetty-${MY_PV}
	cd jetty-${S}
	epatch ${FILESDIR}/${PV}/build-jetty-servlet-api-${MY_PV}.patch
	# FIXME : sed the patch instead of before committed
	find . -name '*maven-build*' -exec sed -i \
		-e 's/home\/asura\/\.m2\/repository/usr\/share/g' \
		{} \;
}


EANT_GENTOO_CLASSPATH=""
EANT_BUILD_TARGET="clean compile package"

src_compile() {
	cd ${S}
	eant package
}

src_install() {
	cd ${S}
	java-pkg_newjar "modules/servlet-api-${PV}/target/servlet-api-${PV}-${MY_PV}.jar"	servlet-api.jar
}

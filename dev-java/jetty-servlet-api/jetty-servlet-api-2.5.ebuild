# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-ant-2
MY_PV=6.1.7
DESCRIPTION="A Lightweight Servlet Engine API"
SRC_URI="http://ftp.mortbay.org/pub/jetty-${MY_PV}/jetty-${MY_PV}-src.zip"
HOMEPAGE="http://www.mortbay.org/"
KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="Apache-1.1"
SLOT="0"
IUSE=""

COMMON_DEP=""

RDEPEND=">=virtual/jre-1.6
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${COMMON_DEP}"
S=jetty-${MY_PV}
src_unpack() {
	unpack ${A}
	cd "jetty-${S}"
	epatch "${FILESDIR}/${PV}/build-jetty-servlet-api-${MY_PV}.patch"
	# FIXME : sed the patch instead of before committed
	find . -name '*maven-build*' -exec sed -i \
		-e 's/home\/asura\/\.m2\/repository/usr\/share/g' \
		{} \;
#	java-ant_rewrite-classpath modules/servlet-api-${PV}/maven-build.xml
}


EANT_GENTOO_CLASSPATH=""
EANT_BUILD_TARGET="clean compile package"

src_compile() {
	cd jetty-${MY_PV} || die "cd failed"
	eant package
}

src_install() {
	java-pkg_newjar "jetty-${MY_PV}/modules/servlet-api-${PV}/target/servlet-api-${PV}-${MY_PV}.jar"	servlet-api.jar
}

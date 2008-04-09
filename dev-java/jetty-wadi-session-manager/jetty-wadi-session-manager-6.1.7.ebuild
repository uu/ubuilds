# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $ 

inherit eutils java-pkg-2 java-ant-2
DESCRIPTION="A Lightweight Servlet Engine API"
SRC_URI="http://ftp.mortbay.org/pub/jetty-${PV}/jetty-${PV}-src.zip"
HOMEPAGE="http://www.mortbay.org/"
KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="Apache-1.1"
SLOT="0"
TRIBES_PV=6.0.16
COMMON_DEP=">=dev-java/jetty-servlet-api-2.5
		=dev-java/jetty-util-${PV}
		=dev-java/jetty-module-${PV}
		dev-java/wadi
		=dev-java/tribes-${TRIBES_PV}"

RDEPEND=">=virtual/jre-1.6
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd jetty-${PV} || die cd failed
	epatch "${FILESDIR}/${PV}/build-jetty-wadi-session-manager-${PV}.patch"
	# FIXME : sed the patch instead of before committed
	find . -name '*maven-build*' -exec sed -i \
		-e 's/home\/asura\/\.m2\/repository/usr\/share/g' \
		{} \;
	java-ant_rewrite-classpath contrib/wadi/maven-build.xml
}

EANT_GENTOO_CLASSPATH="wadi jetty-servlet-api jetty-util jetty-module tribes"
EANT_BUILD_TARGET="clean compile package"

src_compile() {
	cd jetty-${PV}  || die "cd failed"
	eant package
}

src_install() {
	cd jetty-${PV}
	java-pkg_newjar "contrib/wadi/target/jetty-wadi-session-manager-${PV}.jar" jetty-wadi-session-manager.jar
}

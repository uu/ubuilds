# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $ 

JAVA_MAVEN_BUILD_SYSTEM="eant"
EAPI=1

inherit eutils java-pkg-2 java-ant-2
DESCRIPTION="A Lightweight Servlet Engine API"
SRC_URI="http://ftp.mortbay.org/pub/jetty-${PV}/jetty-${PV}-src.zip"
HOMEPAGE="http://www.mortbay.org/"
KEYWORDS="~amd64 ~x86"
LICENSE="Apache-1.1"
SLOT="0"

COMMON_DEP=">=dev-java/jetty-servlet-api-2.5
		=dev-java/jetty-module-${PV}
		=dev-java/jetty-util-${PV}
		=dev-java/jetty-naming-${PV}"

RDEPEND=">=virtual/jre-1.6
	dev-java/glassfish-transaction-api
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${COMMON_DEP}"
#S=jetty-${MY_PV}
src_unpack() {
	unpack ${A}
	cd jetty-${PV} || die cd failed
	epatch "${FILESDIR}/${PV}/build-jetty-plus-${PV}.patch"
	# FIXME : sed the patch instead of before committed
	find . -name '*maven-build*' -exec sed -i \
		-e 's/home\/asura\/\.m2\/repository/usr\/share/g' \
		{} \;
	java-ant_rewrite-classpath modules/plus/maven-build.xml
}

EANT_GENTOO_CLASSPATH="jetty-servlet-api jetty-util jetty-module jetty-naming glassfish-transaction-api"
EANT_BUILD_TARGET="clean compile package"
#JAVA_ANT_REWRITE_CLASSPATH="true"
#JAVA_ANT_IGNORE_SYSTEM_CLASSES="true"

src_compile() {
	cd jetty-${PV}
	eant package
}

src_install() {
	cd jetty-${PV}
	java-pkg_newjar "modules/plus/target/jetty-plus-${PV}.jar" jetty-plus.jar
}

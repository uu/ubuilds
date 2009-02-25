# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"
JAVA_MAVEN_BUILD_SYSTEM="eant"
EAPI=1

inherit subversion eutils java-pkg-2 java-ant-2
#java-maven-2 

DESCRIPTION="Tomcat tribes"
ESVN_REPO_URI="http://svn.apache.org/repos/asf/tomcat/tc6.0.x/tags/TOMCAT_${PV//./_}/java/org/apache/catalina/${PN}"
ESVN_PROJECT="wadi"
HOMEPAGE="http://tomcat.apache.org/"
KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

COMMON_DEP="dev-java/juli"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	cp -i "${FILESDIR}/maven-build.xml-${PV}" "${S}/build.xml" || die "cp failed"
	cp -i "${FILESDIR}/maven-build.properties-${PV}" "${S}/maven-build.properties" || die "cp failed"

#	epatch "${FILESDIR}/${MY_PV}/build-wadi-${MY_PV}.patch"
#	find . -name '*maven-build*' -exec sed -i \
#		-e 's/jse.version=1.5/jse.version=1.6/g' \
#		{} \;
	java-ant_rewrite-classpath
}

EANT_GENTOO_CLASSPATH="juli"
EANT_BUILD_TARGET="clean compile package"
JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_IGNORE_SYSTEM_CLASSES="true"

#src_compile() {
#	eant package
#}

src_install() {
	java-pkg_newjar "target/${P}.jar" ${PN}.jar
	#use doc && java-pkg_dojavadoc "${WORKDIR}/gentoo_javadoc"
	#use source && java-pkg_dosrc src/main/java/*
}

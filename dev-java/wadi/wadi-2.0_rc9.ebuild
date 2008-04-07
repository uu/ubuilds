# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"
JAVA_MAVEN_BUILD_SYSTEM="eant"
EAPI=1

inherit subversion eutils java-pkg-2 java-ant-2
#java-maven-2 

DESCRIPTION="WADI started life as a solution to the problems surrounding the
distribution of state in clustered web tiers. It has evolved into a more
generalised distributed state and service framework."
MY_PV=${PV/_rc/-M}
ESVN_REPO_URI="http://svn.codehaus.org/wadi/branches/${MY_PV}"
ESVN_PROJECT="wadi"
HOMEPAGE="http://wadi.codehaus.org/"
KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

COMMON_DEP=""

RDEPEND=">=virtual/jre-1.5
    ${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
    ${COMMON_DEP}"

src_unpack() {
	subversion_src_unpack
	cd ${S}
	epatch ${FILESDIR}/${MY_PV}/build-wadi-${MY_PV}.patch
#	find . -name '*maven-build*' -exec sed -i \
#		-e 's/jse.version=1.5/jse.version=1.6/g' \
#		{} \;
	java-ant_rewrite-classpath maven-build.xml
}

EANT_GENTOO_CLASSPATH=""
EANT_BUILD_TARGET="clean compile package"
JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_IGNORE_SYSTEM_CLASSES="true"

#src_compile() {
#	eant package
#}

src_install() {
	java-pkg_dojar "wadi-group/target/wadi-group-${MY_PV}.jar"
	java-pkg_dojar "wadi-tribes/target/wadi-tribes-${MY_PV}.jar"
	java-pkg_dojar "wadi-aop/target/wadi-aop-${MY_PV}.jar"
	java-pkg_dojar "wadi-core/target/wadi-core-${MY_PV}.jar"
	java-pkg_dojar "wadi-jgroups/target/wadi-jgroups-${MY_PV}.jar"
	#use doc && java-pkg_dojavadoc "${WORKDIR}/gentoo_javadoc"
	#use source && java-pkg_dosrc src/main/java/*

}

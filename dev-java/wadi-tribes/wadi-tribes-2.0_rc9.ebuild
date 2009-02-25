# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"
JAVA_MAVEN_BUILD_SYSTEM="eant"
EAPI=1

inherit subversion eutils java-pkg-2 java-ant-2

DESCRIPTION="WADI started life as a solution to the problems surrounding the
distribution of state in clustered web tiers. It has evolved into a more
generalised distributed state and service framework."
MY_PV=${PV/_rc/-M}
ESVN_REPO_URI="http://svn.codehaus.org/wadi/branches/${MY_PV}/${PN}"
HOMEPAGE="http://wadi.codehaus.org/"
KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

COMMON_DEP="dev-java/wadi-core
			dev-java/wadi-group
			dev-java/tribes
			dev-java/juli
			dev-java/commons-logging"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	epatch "${FILESDIR}/${MY_PV}/build-${PN}.patch"
	# FIXME : sed the patch instead of before committed
	find . -name '*maven-build*' -exec sed -i \
		-e 's/home\/asura\/\.m2\/repository/usr\/share/g' \
		{} \;
	java-ant_rewrite-classpath maven-build.xml
}

EANT_GENTOO_CLASSPATH="wadi-core wadi-group tribes juli commons-logging"
EANT_BUILD_TARGET="clean compile package"
JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_IGNORE_SYSTEM_CLASSES="true"

src_install() {
	java-pkg_newjar "target/${PN}-${MY_PV}.jar"
	#use doc && java-pkg_dojavadoc "${WORKDIR}/gentoo_javadoc"
	#use source && java-pkg_dosrc src/main/java/*

}

# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-utils-2 subversion 

DESCRIPTION="DbUnit is a JUnit extension targeted for database-driven projects"
HOMEPAGE="http://www.dbunit.org/"
ESVN_REPO_URI="https://dbunit.svn.sourceforge.net/svnroot/dbunit/trunk"
ESVN_PROJECT="dbunit"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""

IUSE=""

COMMON_DEP="dev-java/slf4j-api
			dev-java/slf4j-log4j12
			dev-java/slf4j-nop
			dev-java/ant-core
			>=dev-java/poi-3.2
			dev-java/commons-collections
			dev-java/commons-logging
			dev-java/maven-bin
			dev-java/junit
			"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}/${PN}"

src_unpack(){
	if [[ ${PV} == "9999" ]] ; then
		subversion_src_unpack
		cd "${S}"
		epatch "${FILESDIR}"/svnjarname.patch
	fi
	mkdir "${S}"/lib
	java-pkg_jar-from --into lib poi-3.2
	java-pkg_jar-from --into lib junit
	java-pkg_jar-from --into lib slf4j-api
	java-pkg_jar-from --into lib slf4j-log4j12
	java-pkg_jar-from --into lib commons-collections
	java-pkg_jar-from --into lib commons-logging
	java-pkg_jar-from --into lib ant-core
	java-pkg_jar-from --into lib log4j
}

src_compile(){
	mvn compile || die "compile failed"

	if use doc ; then
		mvn site || die "docs failed"
	fi
}

src_test(){
	ewarn "Running tests with hypersonic profile ..."
	mvn test || die "Tests Failed"
}

src_install() {
	mvn jar:jar || die "install failed"
	cd "${S}"/target
	java-pkg_dojar "${PN}"-"${PV}".jar

	if use doc ; then
		cd "${S}"/target/
		java-pkg_dojavadoc site
	fi

	cd "${S}"
	use source && java-pkg_dosrc src
}

pkg_postinst(){
	einfo "See: http://dbunit.wikidot.com/"
	einfo "for More Info"
}

# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2 java-utils-2

DESCRIPTION="DbUnit is a JUnit extension targeted for database-driven projects"
HOMEPAGE="http://dbunit.sourceforge.net/"
SRC_URI="http://internap.dl.sourceforge.net/sourceforge/dbunit/${P}-sources.jar"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""

COMMON_DEP="dev-java/slf4j-api
		    dev-java/slf4j-log4j12
			dev-java/slf4j-nop
			>=dev-java/poi-3.2
			dev-java/commons-collections:0
			dev-java/commons-logging:0
			dev-java/ant-core
			dev-java/log4j
			dev-java/junit"
			
RDEPEND=">=virtual/jre-1.4 
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"
	
#instead of making a folder
S="${WORKDIR}"

JAVA_PKG_DEBUG="yes"
JAVA_PKG_BSFIX="off"

src_unpack(){
	unpack ${A}
	cd "${S}"
	#Upstream no longer provides a build file. 
	cp -v "${FILESDIR}"/build.xml "${S}/build.xml" || die
	#Create needed libdir to put jars in
	mkdir "${S}/lib"
	java-pkg_jar-from --into lib poi-3.2 
	java-pkg_jar-from --into lib junit
	java-pkg_jar-from --into lib slf4j-api
	java-pkg_jar-from --into lib slf4j-log4j12
	java-pkg_jar-from --into lib commons-collections
	java-pkg_jar-from --into lib commons-logging
	java-pkg_jar-from --into lib ant-core
	java-pkg_jar-from --into lib log4j

	
}

src_install() {
	#slf4j needed for runtime
	java-pkg_register-dependency  slf4j-nop
	java-pkg_dojar "${S}"/dist/"${PN}.jar"
	use doc && java-pkg_dojavadoc build/javadoc
	use source && java-pkg_dosrc org
}


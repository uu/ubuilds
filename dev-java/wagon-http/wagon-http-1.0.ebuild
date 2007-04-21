# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-maven-2

DESCRIPTION="The Wagon API project defines a simple API for transfering resources (artifacts) to and from repositories"
# svn co http://svn.apache.org/repos/asf/maven/wagon/tags/*/wagon-provider-api/ wagon-provider-api
SRC_URI="http://dev.gentooexperimental.org/~kiorky/${P}.tar.bz2"

SLOT="0"
KEYWORDS="~x86"
IUSE="source doc"
LICENSE="Apache-2.0"
HOMEPAGE="http://maven.apache.org"

DEP="dev-java/jtidy
	dev-java/wagon-provider-api
	dev-java/plexus-utils
	dev-java/plexus-container-default
	dev-java/plexus-jetty-httpd
	dev-java/wagon-http-shared
	dev-java/commons-logging
	dev-java/commons-lang
	=dev-java/commons-httpclient-2*"
DEPEND=">=virtual/jdk-1.4 ${DEP}"
RDEPEND=">=virtual/jre-1.4 ${DEP}"
EANT_GENTOO_CLASSPATH="jtidy
	wagon-provider-api
	plexus-utils
	plexus-container-default
	plexus-jetty-httpd
	wagon-http-shared
	commons-logging
	commons-lang
	commons-httpclient"

src_compile() {
	java-pkg-2_src_compile
}


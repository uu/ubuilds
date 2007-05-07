# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-maven-2

DESCRIPTION="The Plexus project provides a full software stack for creating and executing software projects."
HOMEPAGE="http://plexus.codehaus.org/"

SRC_URI="http://dev.gentooexperimental.org/~kiorky/${P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE="source"
DEP="=www-servers/jetty-5* dev-java/tomcat-jasper dev-java/plexus-component-api"
DEPEND=">=virtual/jdk-1.4 	${DEP}"
RDEPEND=">=virtual/jre-1.4	${DEP}"

EANT_GENTOO_CLASSPATH="jetty-5 tomcat-jasper-2 plexus-component-api"

src_unpack(){
	java-maven-2_src_unpack
	epatch ${FILESDIR}/DefaultHttpd.java.diff
}


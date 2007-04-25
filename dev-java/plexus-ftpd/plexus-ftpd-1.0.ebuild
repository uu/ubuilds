# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-maven-2

DESCRIPTION="The Plexus project provides a full software stack for creating and executing software projects."
HOMEPAGE="http://plexus.codehaus.org/"

SRC_URI="http://dev.gentooexperimental.org/~kiorky/${P}.tar.bz2"

LICENSE="as-is" # http://plexus.codehaus.org/plexus-utils/license.html
SLOT="0"
KEYWORDS="~x86"
IUSE="source doc"
DEP="=www-servers/jetty-5*
dev-java/tomcat-jasper
dev-java/plexus-component-api
dev-java/plexus-utils
dev-java/cornerstone-connection
dev-java/concurrent-util
=dev-java/avalon-framework-4.1*
dev-java/commons-collections
dev-java/excalibur-pool
dev-java/cornerstone-sockets
dev-java/plexus-avalon-personality
dev-java/cornerstone-threads"
DEPEND=">=virtual/jdk-1.4 	${DEP}"
RDEPEND=">=virtual/jre-1.4	${DEP}"

EANT_EXTRA_FLAGS="-Dproject.name=${PN}"
EANT_GENTOO_CLASSPATH="jetty-5
tomcat-jasper-2
plexus-component-api
plexus-avalon-personality
plexus-utils
cornerstone-connection
commons-collections
cornerstone-sockets
concurrent-util
avalon-framework-4.1
excalibur-pool
cornerstone-threads"


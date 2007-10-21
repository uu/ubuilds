# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_MAVEN_BOOTSTRAP="Y"
inherit java-pkg-2 java-maven-2

DESCRIPTION="The Plexus project provides a full software stack for creating and executing software projects."
HOMEPAGE="http://plexus.codehaus.org/"
SRC_URI="http://dev.gentooexperimental.org/~kiorky/${P}.tar.bz2"
LICENSE="as-is" # http://plexus.codehaus.org/plexus-utils/license.html
SLOT="0"
KEYWORDS="~x86"
IUSE="source doc"
COMMON_DEPS="
dev-java/sun-javamail
dev-java/plexus-utils
dev-java/plexus-container-default
dev-java/plexus-component-api
"
DEPEND=">=virtual/jdk-1.4 	${COMMON_DEPS}"
RDEPEND=">=virtual/jre-1.4	${COMMON_DEPS}"
EANT_EXTRA_FLAGS="-Dproject.name=${PN}"
JAVA_MAVEN_CLASSPATH="
sun-javamail
plexus-utils
plexus-container-default
plexus-component-api
"
JAVA_MAVEN_PROJECTS="
plexus-mail-sender-api
plexus-mail-senders/plexus-mail-sender-javamail
plexus-mail-senders/plexus-mail-sender-simple
plexus-mail-senders
"


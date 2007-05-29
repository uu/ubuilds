# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_MAVEN_BOOTSTRAP="Y"
inherit java-maven-2

DESCRIPTION="The Plexus project provides a full software stack for creating and executing software projects."
HOMEPAGE="http://plexus.codehaus.org/"
SRC_URI="http://dev.gentooexperimental.org/~kiorky/${P}.tar.bz2"
LICENSE="as-is" # http://plexus.codehaus.org/plexus-utils/license.html
SLOT="1.0_alpha14"
KEYWORDS="~x86"
IUSE="source"
DEP="=dev-java/plexus-classworlds-1.2*
dev-java/plexus-utils
dev-java/junit
=dev-java/plexus-component-api-1.0_alpha14"
DEPEND=">=virtual/jdk-1.4 ${DEP}"
RDEPEND=">=virtual/jre-1.4 ${DEP}"
EANT_GENTOO_CLASSPATH="
plexus-classworlds
plexus-utils
junit
plexus-component-api-1.0_alpha14"


# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source"
JAVA_MAVEN_BOOTSTRAP="Y"
inherit java-maven-2

DESCRIPTION="Maven is a software project management and comprehension tool."
SRC_URI="http://dev.gentooexperimental.org/~kiorky/${P}.tar.bz2"
HOMEPAGE="http://maven.apache.org/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEP="dev-java/maven-artifact
dev-java/maven-repository-metadata
=dev-java/plexus-container-default-1.0_alpha9
dev-java/plexus-utils
dev-java/wagon-file
=dev-java/classworlds-1.1*
dev-java/wagon-provider-api"
#for tests only dev-java/easymock
DEPEND=">=virtual/jdk-1.4 ${DEP}"
RDEPEND=">=virtual/jre-1.4 ${DEP}"
JAVA_MAVEN_CLASSPATH="maven-artifact
maven-repository-metadata
plexus-container-default-1.0_alpha9
classworlds-1.1
plexus-utils
wagon-file
wagon-provider-api"
#for tests only easymock

RESTRICT=test
JAVA_PKG_SRC_DIRS="src/main/java/*"


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
dev-java/maven-artifact-manager
dev-java/maven-settings
dev-java/junit
dev-java/wagon-provider-api
dev-java/plexus-utils
=dev-java/plexus-container-default-1.0_alpha9"
DEPEND=">=virtual/jdk-1.4 ${DEP}"
RDEPEND=">=virtual/jre-1.4 ${DEP}"
EANT_GENTOO_CLASSPATH="maven-artifact
maven-artifact-manager
wagon-provider-api
junit
maven-settings
plexus-utils
plexus-container-default-1.0_alpha9"

RESTRICT=test
JAVA_PKG_SRC_DIRS="src/main/java/*"

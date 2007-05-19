# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


JAVA_PKG_IUSE="source" #no javadoc target

IS_MODELLO_EBUILD="y"
inherit java-maven-2

DESCRIPTION="Maven is a software project management and comprehension tool."
HOMEPAGE="http://maven.apache.org/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEP="dev-java/maven-model dev-java/plexus-utils =dev-java/plexus-container-default-1.0_alpha9"
DEPEND=">=virtual/jdk-1.4 ${DEP}"
RDEPEND=">=virtual/jre-1.4 ${DEP}"
EANT_GENTOO_CLASSPATH="maven-model plexus-utils plexus-container-default-1.0_alpha9"

RESTRICT=test
JAVA_PKG_SRC_DIRS="src/main/java/*"

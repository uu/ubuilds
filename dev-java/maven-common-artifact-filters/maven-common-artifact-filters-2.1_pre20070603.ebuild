# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source" #no javadoc target

JAVA_MAVEN_BOOTSTRAP="Y"
inherit java-maven-2

DESCRIPTION="Maven is a software project management and comprehension tool."
SRC_URI="http://dev.gentooexperimental.org/~kiorky/${P}.tar.bz2"
HOMEPAGE="http://maven.apache.org/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
COMMON_DEPS="
dev-java/junit
dev-java/maven-artifact
dev-java/maven-model
dev-java/maven-test-tools
dev-java/maven-plugin-api
dev-java/plexus-container-default
dev-java/plexus-component-api 
dev-java/plexus-utils
"
DEPEND=">=virtual/jdk-1.4 ${COMMON_DEPS}"
RDEPEND=">=virtual/jre-1.4 ${COMMON_DEPS}"
JAVA_MAVEN_CLASSPATH="
maven-test-tools
junit
plexus-component-api  
maven-model
maven-artifact
maven-plugin-api
plexus-container-default
plexus-utils
"

RESTRICT=test
JAVA_PKG_SRC_DIRS="src/main/java/*"


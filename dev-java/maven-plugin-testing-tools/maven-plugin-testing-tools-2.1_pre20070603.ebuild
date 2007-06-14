# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source" #no javadoc target
JAVA_MAVEN_ADD_GENERATED_STUFF="y"
JAVA_MAVEN_BOOTSTRAP="Y"
inherit java-maven-plugin-2

DESCRIPTION="Maven is a software project management and comprehension tool."
HOMEPAGE="http://maven.apache.org/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
COMMON_DEPS="
dev-java/maven-test-tools
dev-java/plexus-utils
dev-java/maven-invoker*
dev-java/maven-settings
"
DEPEND=">=virtual/jdk-1.4 ${COMMON_DEPS}"
RDEPEND=">=virtual/jre-1.4 ${COMMON_DEPS}"
JAVA_MAVEN_CLASSPATH="
plexus-utils
maven-invoker
maven-test-tools
maven-settings
"
RESTRICT=test
JAVA_PKG_SRC_DIRS="src/main/java/*"
JAVA_MAVEN_PATCHES="${FILESDIR}/maven.patch"


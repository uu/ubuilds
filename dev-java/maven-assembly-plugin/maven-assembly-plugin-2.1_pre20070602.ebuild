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
dev-java/easymock
=dev-java/jaxen-1.1*
=dev-java/jdom-1.0*
dev-java/maven-archiver
dev-java/maven-plugin-testing-tools
dev-java/file-management
dev-java/maven-plugin-tools
dev-java/maven-repository-builder
dev-java/plexus-archiver
dev-java/saxpath
"

DEPEND=">=virtual/jdk-1.4 ${COMMON_DEPS}"
RDEPEND=">=virtual/jre-1.4 ${COMMON_DEPS}"
JAVA_MAVEN_CLASSPATH="
easymock-1
jaxen-1.1
jdom-1.0
maven-archiver
maven-plugin-testing-tools
maven-plugin-tools
file-management
maven-repository-builder
plexus-archiver
saxpath
"

RESTRICT=test
JAVA_PKG_SRC_DIRS="src/main/java/*"
JAVA_MAVEN_PATCHES="${FILESDIR}/maven.patch"


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
dev-java/plexus-utils 
=dev-java/easymock-1*
"
#dev-java/maven-artifact
#dev-java/maven-artifact-manager
#dev-java/maven-core
#dev-java/maven-model
#dev-java/maven-plugin-api
#dev-java/maven-project
#dev-java/plexus-classworlds
#dev-java/plexus-component-api
#dev-java/plexus-container-default
#
#dev-java/wagon-provider-api
#"
DEPEND=">=virtual/jdk-1.4 ${COMMON_DEPS}"
RDEPEND=">=virtual/jre-1.4 ${COMMON_DEPS}"
JAVA_MAVEN_CLASSPATH="
junit
plexus-utils 
easymock-1
"
#maven-artifact
#maven-artifact-manager
#maven-core
#maven-model
#maven-plugin-api
#maven-project
#plexus-classworlds
#plexus-component-api
#plexus-container-default
#
#wagon-provider-api
#"
#
RESTRICT=test
JAVA_PKG_SRC_DIRS="src/main/java/*"


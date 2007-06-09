# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source" #no javadoc target

JAVA_MAVEN_BOOTSTRAP="Y"
inherit java-maven-2

DESCRIPTION="Maven is a software project management and comprehension tool."
MY_BASE_URL="http://dev.gentooexperimental.org/~kiorky"
SRC_URI="${MY_BASE_URL}/${P}.tar.bz2
${MY_BASE_URL}/${PN}_model_gen_src-${PV}.tar.bz2
"
HOMEPAGE="http://maven.apache.org/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
COMMON_DEPS="
dev-java/bsh
=dev-java/easymock-1*
dev-java/junit
dev-java/maven-model
dev-java/maven-plugin-descriptor
dev-java/plexus-container-default
dev-java/plexus-utils
=dev-java/plexus-container-default-1.0_alpha9
dev-java/maven-project
dev-java/qdox
"
DEPEND=">=virtual/jdk-1.4 ${COMMON_DEPS}"
RDEPEND=">=virtual/jre-1.4 ${COMMON_DEPS}"
JAVA_MAVEN_CLASSPATH="
maven-plugin-descriptor
bsh
easymock-1
junit
maven-project
maven-model
plexus-container-default-1.0_alpha9 
plexus-container-default
plexus-utils
qdox-1.6
"
RESTRICT=test
JAVA_PKG_SRC_DIRS="src/main/java/*"
JAVA_MAVEN_PROJECTS="
maven-plugin-tools-model 
maven-plugin-tools-api
maven-plugin-tools-java
maven-plugin-tools-ant
maven-plugin-tools-beanshell
"


src_unpack() {
	java-maven-2_src_unpack
	cd "${S}/maven-plugin-tools-model/src/main/java" || die
	unpack  "${PN}_model_gen_src-${PV}.tar.bz2"

}














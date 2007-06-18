# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-maven-2

HOMEPAGE="http://maven.apache.org"
LICENSE="Apache-2.0"

JAVA_MAVEN_PLUGIN_COMMON_DEPS="
dev-java/maven-base-poms
dev-java/maven-artifact
dev-java/maven-core
dev-java/maven-model
dev-java/maven-plugin-api
dev-java/maven-plugin-descriptor
dev-java/plexus-classworlds
dev-java/plexus-component-api
dev-java/plexus-container-default
dev-java/plexus-utils
dev-java/maven-project
dev-java/maven-settings
dev-java/junit
dev-java/wagon-provider-api
dev-java/maven-shared-components
"
JAVA_MAVEN_PLUGIN_CLASSPATH="
maven-artifact
maven-core
junit
maven-settings
maven-model
maven-project
maven-plugin-api
maven-plugin-descriptor
plexus-classworlds
plexus-component-api
plexus-container-default
plexus-utils
maven-shared-components
wagon-provider-api
"

RDEPEND=">=virtual/jre-1.4 ${JAVA_MAVEN_PLUGIN_COMMON_DEPS}"
DEPEND=">=virtual/jdk-1.4  ${JAVA_MAVEN_PLUGIN_COMMON_DEPS}"

java-maven-plugin-2_src_unpack() {
	java-maven-2_src_unpack
}

# if you override, think to append the eclass classpath.
java-maven-plugin-2_src_compile() {
	JAVA_MAVEN_CLASSPATH="${JAVA_MAVEN_CLASSPATH} ${JAVA_MAVEN_PLUGIN_CLASSPATH}"
	java-maven-2_src_compile
}

java-maven-plugin-2_src_install() {
	java-maven-2_src_install
}

EXPORT_FUNCTIONS src_unpack src_compile src_install


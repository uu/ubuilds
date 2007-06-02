# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_MAVEN_BOOTSTRAP="Y"
inherit java-utils-2 java-maven-2

MY_PN=maven

DESCRIPTION="The core of Maven"
HOMEPAGE="http://maven.apache.org"
SRC_URI="http://dev.gentooexperimental.org/~kiorky/${PF}.tar.bz2"
DEPS="=dev-java/classworlds-1.1*
=dev-java/commons-cli-1*
dev-java/commons-lang
=dev-java/commons-lang-2.1*
dev-java/commons-logging
=dev-java/plexus-container-default-1.0_alpha9
dev-java/plexus-interactivity-api
=dev-java/plexus-utils-1.0.4
dev-java/wagon-ssh
dev-java/doxia
dev-java/wagon-ssh-external
dev-java/wagon-http-lightweight
dev-java/wagon-provider-api
dev-java/maven-artifact
dev-java/maven-artifact-manager
dev-java/maven-model
dev-java/maven-monitor
dev-java/maven-plugin-api
dev-java/maven-plugin-registry
dev-java/maven-plugin-descriptor
dev-java/maven-plugin-parameter-documenter
dev-java/maven-profile
dev-java/maven-project
dev-java/maven-error-diagnostics
dev-java/maven-reporting-api
dev-java/maven-repository-metadata
dev-java/maven-settings"
DEPEND=">=virtual/jdk-1.4 ${DEPS}
source? ( app-arch/zip )"
RDEPEND=">=virtual/jre-1.4 ${DEPS}"
KEYWORDS="~x86"
IUSE="doc source"
SLOT="0"
EANT_GENTOO_CLASSPATH="
classworlds-1.1
commons-cli-1
commons-lang-2.1
doxia
commons-logging
plexus-container-default-1.0_alpha9
plexus-interactivity-api
plexus-utils-1.0.4
wagon-http-lightweight
wagon-provider-api
wagon-ssh
wagon-ssh-external
maven-artifact
maven-artifact-manager
maven-model
maven-monitor
maven-error-diagnostics
maven-plugin-api
maven-plugin-descriptor
maven-plugin-parameter-documenter
maven-plugin-registry
maven-profile
maven-project
maven-reporting-api
maven-repository-metadata
maven-settings
"

#JAVA_MAVEN_PATCHES="${FILESDIR}/addsystemclasspath.patch"


#S="${WORKDIR}/${PF}"

src_unpack() {
	java-maven-2_src_unpack
#	epatch "${FILESDIR}/MavenCli.java.diff"
	mkdir -p "${S}/src/main/resources" || die
	cp "${FILESDIR}/pom.properties" "${S}/src/main/resources" || die
}

src_install() {
	java-maven-2_src_install

	# default configuration
	dodir "${JAVA_MAVEN_SYSTEM_HOME}"
	insinto "${JAVA_MAVEN_SYSTEM_HOME}"
	doins  "${S}/src/conf/settings.xml"


	# create plugins and systtem repository directories
	keepdir "${JAVA_MAVEN_SYSTEM_PLUGINS}"
	keepdir "${JAVA_MAVEN_SYSTEM_REPOSITORY}"


}


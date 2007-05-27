# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-maven-2 java-pkg-2 java-utils-2

DESCRIPTION="The core of Maven"
LICENSE="Apache-2.0"
HOMEPAGE="http://maven.apache.org"
DEPS="=dev-java/maven-script-${PV}*
=dev-java/maven-core-${PV}*
dev-java/maven-artifact
dev-java/maven-artifact-manager
dev-java/maven-artifact-test
dev-java/maven-error-diagnostics
dev-java/maven-model
dev-java/maven-monitor
dev-java/maven-plugin-api
dev-java/maven-plugin-descriptor
dev-java/maven-plugin-parameter-documenter
dev-java/maven-plugin-registry
dev-java/maven-profile
dev-java/maven-project
dev-java/maven-reporting-api
dev-java/maven-repository-metadata
dev-java/maven-script
dev-java/maven-settings
dev-java/wagon-file
dev-java/wagon-ftp
dev-java/wagon-http
dev-java/wagon-http-lightweight
dev-java/wagon-http-shared
dev-java/wagon-provider-api
dev-java/wagon-ssh
dev-java/wagon-ssh-common
dev-java/wagon-ssh-common-test
dev-java/wagon-ssh-external
dev-java/jtidy
=dev-java/commons-cli-1*
dev-java/plexus-utils
dev-java/jsch
dev-java/plexus-interactivity-api
dev-java/plexus-avalon-personality
=dev-java/plexus-container-default-1.0_alpha9*
"
DEPEND=">=virtual/jdk-1.4 ${DEPS}
source? ( app-arch/zip )"
RDEPEND=">=virtual/jre-1.4 ${DEPS}"
KEYWORDS="~x86"
IUSE="doc source"
SLOT="2"

MAVEN_UBERJAR_FAKE="
maven-artifact
maven-artifact-manager
maven-artifact-test
maven-core-2
maven-error-diagnostics
maven-model
maven-monitor
maven-plugin-api
maven-plugin-descriptor
maven-plugin-parameter-documenter
maven-plugin-registry
maven-profile
maven-project
maven-reporting-api
maven-repository-metadata
maven-script
maven-settings
wagon-file
wagon-ftp
wagon-http
wagon-http-lightweight
wagon-http-shared
wagon-provider-api
wagon-ssh
wagon-ssh-common
wagon-ssh-common-test
wagon-ssh-external
jtidy
commons-cli-1
plexus-utils
jsch
plexus-interactivity-api
plexus-avalon-personality
plexus-container-default-1.0_alpha9
"

src_unpack() {
	mkdir -p "${S}/gentoo_maven_jars" || die

	cd "${S}/gentoo_maven_jars" || die
	for i in ${MAVEN_UBERJAR_FAKE};do
		java-pkg_jar-from ${i}
	done

	# copy our pom
	cd "${S}" || die
	cp "${FILESDIR}/maven-${PV}.pom" pom.xml || die

	# generate our launch script
	if [[ ! -f mvn ]];then
		echo "#!/bin/sh" >> mvn
		echo "\$(java-config -J) \\" >> mvn
		echo "-classpath \$(java-config -p classworlds-1.1) \\" >> mvn
		echo "-Dclassworlds.conf=${JAVA_MAVEN_SYSTEM_HOME}/conf/m2_classworlds.conf \\" >> mvn
	#	echo "-Dmaven.core.path=/usr/share/${PN}-${SLOT} \\" >> mvn
		echo "-Dmaven.home=${JAVA_MAVEN_SYSTEM_HOME} \\" >> mvn
		echo "-Dmaven.plugin.dir=${JAVA_MAVEN_SYSTEM_PLUGINS} \\" >> mvn
		echo "-Dmaven.repo.remote=file:/${JAVA_MAVEN_SYSTEM_REPOSITORY} \\" >> mvn
		echo "-Dmaven.repo.local=file:/${JAVA_MAVEN_SYSTEM_REPOSITORY} \\" >> mvn
		echo "org.codehaus.classworlds.Launcher \${@} " >> mvn
	else
		die "mvn file allready exists"
	fi
}

src_install() {
	# register maven pom
	java-maven-2_install_one

	# replacement for maven uberjar
	cd "${S}/gentoo_maven_jars" || die
	for i in $(ls -1 .); do
		java-pkg_dojar ${i}
	done

	cd "${S}" || die

	# classworlds and basic maven configurations
	keepdir "${JAVA_MAVEN_SYSTEM_HOME}/conf"
	insinto "${JAVA_MAVEN_SYSTEM_HOME}/conf"
	doins "${FILESDIR}/m2_classworlds.conf"
	doins "${FILESDIR}/settings.xml"

	# install our launchers
	chmod 755 "${S}/mvn" || die
	exeinto /usr/bin
	doexe  "${S}/mvn"
}


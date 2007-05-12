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

src_unpack() {
	mkdir -p "${S}" "${S}/img" || die
	cd "${S}" || die

	java-pkg_jar-from maven-artifact
	java-pkg_jar-from maven-artifact-manager
	java-pkg_jar-from maven-artifact-test
	java-pkg_jar-from maven-core-2
	java-pkg_jar-from maven-error-diagnostics
	java-pkg_jar-from maven-model
	java-pkg_jar-from maven-monitor
	java-pkg_jar-from maven-plugin-api
	java-pkg_jar-from maven-plugin-descriptor
	java-pkg_jar-from maven-plugin-parameter-documenter
	java-pkg_jar-from maven-plugin-registry
	java-pkg_jar-from maven-profile
	java-pkg_jar-from maven-project
	java-pkg_jar-from maven-reporting-api
	java-pkg_jar-from maven-repository-metadata
	java-pkg_jar-from maven-script
	java-pkg_jar-from maven-settings

	java-pkg_jar-from wagon-file
	java-pkg_jar-from wagon-ftp
	java-pkg_jar-from wagon-http
	java-pkg_jar-from wagon-http-lightweight
	java-pkg_jar-from wagon-http-shared
	java-pkg_jar-from wagon-provider-api
	java-pkg_jar-from wagon-ssh
	java-pkg_jar-from wagon-ssh-common
	java-pkg_jar-from wagon-ssh-common-test
	java-pkg_jar-from wagon-ssh-external
	java-pkg_jar-from jtidy
	java-pkg_jar-from commons-cli-1
	java-pkg_jar-from plexus-utils
	java-pkg_jar-from jsch
	java-pkg_jar-from plexus-interactivity-api
	java-pkg_jar-from plexus-avalon-personality
	java-pkg_jar-from plexus-container-default-1.0_alpha9-maven

	# generate our launch script
	echo "#!/bin/sh" >> mvn
	echo "\$(java-config -J) \\" >> mvn
	echo "-classpath \$(java-config -p classworlds-1.1) \\" >> mvn
	echo "-Dclassworlds.conf=/usr/share/${PN}-${SLOT}/m2_classworlds.conf \\" >> mvn
	echo "-Dmaven.core.path=/usr/share/${PN}-${SLOT} \\" >> mvn
	echo "-Dmaven.home=${JAVA_MAVEN_SYSTEM_HOME} \\" >> mvn
	echo "-Dmaven.plugin.dir=${JAVA_MAVEN_SYSTEM_PLUGINS} \\" >> mvn
	echo "-Dmaven.repo.remote=file:/${JAVA_MAVEN_SYSTEM_REPOSITORY} \\" >> mvn
	echo "org.codehaus.classworlds.Launcher \$* " >> mvn

}

src_install() {
	for i in *.jar; do
		unzip -od img $i
	done
	cd img || die
	jar -cvf maven-uber.jar *
	java-pkg_dojar maven-uber.jar

	cd ..
	insinto "/usr/share/${PN}-${SLOT}"
	doins "${FILESDIR}/m2_classworlds.conf"

	chmod 755 "${S}/mvn"
	exeinto /usr/bin
	doexe  "${S}/mvn-non-bin"
}


# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-maven-2

DESCRIPTION="Maven is a software project management and comprehension tool."
HOMEPAGE="http://maven.apache.org/"
SRC_URI="http://dev.gentooexperimental.org/~kiorky/${P}.tar.bz2"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"
IUSE="source doc"
DEP="dev-java/maven-artifact
dev-java/maven-artifact-manager
dev-java/maven-artifact-test
dev-java/maven-model
dev-java/wagon-provider-api
dev-java/maven-plugin-registry
dev-java/maven-profile
dev-java/maven-settings
dev-java/maven-repository-metadata
=dev-java/plexus-container-default-1.0_alpha9
dev-java/plexus-utils"
DEPEND=">=virtual/jdk-1.4 ${DEP}"
RDEPEND=">=virtual/jre-1.4 ${DEP}"
EANT_GENTOO_CLASSPATH="maven-artifact
maven-artifact-manager
maven-artifact-test
wagon-provider-api
maven-model
maven-plugin-registry
maven-repository-metadata
maven-profile
maven-settings
plexus-container-default-1.0_alpha9-maven
plexus-utils"


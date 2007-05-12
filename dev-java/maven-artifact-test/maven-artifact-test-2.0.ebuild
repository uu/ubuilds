# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-maven-2

DESCRIPTION="Maven is a software project management and comprehension tool."
SRC_URI="http://dev.gentooexperimental.org/~kiorky/${P}.tar.bz2"
HOMEPAGE="http://maven.apache.org/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"
IUSE="source doc"
DEP="dev-java/maven-artifact
dev-java/maven-artifact-manager
dev-java/maven-settings
dev-java/wagon-provider-api
dev-java/plexus-utils
=dev-java/plexus-container-default-1.0_alpha9"
DEPEND=">=virtual/jdk-1.4 ${DEP}"
RDEPEND=">=virtual/jre-1.4 ${DEP}"
EANT_GENTOO_CLASSPATH="maven-artifact
maven-artifact-manager
wagon-provider-api
maven-settings
plexus-utils
plexus-container-default-1.0_alpha9"


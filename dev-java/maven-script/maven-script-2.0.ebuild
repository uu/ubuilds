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
DEP="=dev-java/plexus-container-default-1.0_alpha24
dev-java/plexus-component-api
dev-java/plexus-component-factories
=dev-java/classworlds-1.1*
dev-java/maven-plugin-api
dev-java/plexus-classworlds
dev-java/bsh
dev-java/plexus-utils"
DEPEND=">=virtual/jdk-1.4 ${DEP}"
RDEPEND=">=virtual/jre-1.4 ${DEP}"
EANT_GENTOO_CLASSPATH="
maven-plugin-api
classworlds-1.1
plexus-classworlds
plexus-component-factories
plexus-component-api
bsh
plexus-container-default
plexus-utils"
EMAVEN_PROJECTS="maven-script-ant maven-script-beanshell"



src_unpack(){
	java-maven-2_src_unpack
	epatch "${FILESDIR}/AntMojoComponentFactory.java.diff"
}



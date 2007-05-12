# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-maven-2

DESCRIPTION="The Plexus project provides a full software stack for creating and executing software projects."
HOMEPAGE="http://plexus.codehaus.org/"

SRC_URI="http://dev.gentooexperimental.org/~kiorky/${P}.tar.bz2"

LICENSE="as-is" # http://plexus.codehaus.org/plexus-utils/license.html
SLOT="0"
KEYWORDS="~x86"
IUSE="source"
DEP="=dev-java/avalon-framework-4.1*
=dev-java/plexus-container-default-1.0_alpha9*
dev-java/xpp3
dev-java/plexus-utils"
#dev-java/plexus-component-api"
DEPEND=">=virtual/jdk-1.4 	${DEP}"
RDEPEND=">=virtual/jre-1.4	${DEP}"

EANT_EXTRA_FLAGS="-Dproject.name=${PN}"
EANT_GENTOO_CLASSPATH="avalon-framework-4.1
plexus-container-default-1.0_alpha9
xpp3
plexus-utils"
#plexus-component-api"

src_unpack(){
	java-maven-2_src_unpack
	epatch "${FILESDIR}"/AvalonComponentRepository.java.diff
	epatch "${FILESDIR}"/AvalonLifecycleHandler.java.diff
	epatch "${FILESDIR}"/ComposePhase.java.diff
	epatch "${FILESDIR}"/ConfigurePhase.java.diff
	epatch "${FILESDIR}"/ContextualizePhase.java.diff
	epatch "${FILESDIR}"/DisposePhase.java.diff
	epatch "${FILESDIR}"/InitializePhase.java.diff
	epatch "${FILESDIR}"/LogDisablePhase.java.diff
	epatch "${FILESDIR}"/LogEnablePhase.java.diff
	epatch "${FILESDIR}"/ReconfigurePhase.java.diff
	epatch "${FILESDIR}"/RecontextualizePhase.java.diff
	epatch "${FILESDIR}"/ResumePhase.java.diff
	epatch "${FILESDIR}"/ServicePhase.java.diff
	epatch "${FILESDIR}"/StartPhase.java.diff
	epatch "${FILESDIR}"/StopPhase.java.diff
	epatch "${FILESDIR}"/SuspendPhase.java.diff
}


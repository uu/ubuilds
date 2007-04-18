# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-maven-2

DESCRIPTION="The Wagon API project defines a simple API for transfering resources (artifacts) to and from repositories"
# svn co http://svn.apache.org/repos/asf/maven/wagon/tags/*/wagon-provider-api/ wagon-provider-api
SRC_URI="http://dev.gentooexperimental.org/~kiorky/${P}.tar.bz2"

SLOT="1"
KEYWORDS="~x86"
IUSE="source doc"

DEP="dev-java/plexus-utils"
DEPEND=">=virtual/jdk-1.4 ${DEP}"
RDEPEND=">=virtual/jre-1.4 ${DEP}"
EANT_GENTOO_CLASSPATH="plexus-utils"

src_compile() {
	java-pkg-2_src_compile
}


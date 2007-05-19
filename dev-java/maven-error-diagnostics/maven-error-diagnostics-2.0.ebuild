# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source doc"
inherit java-maven-2

DESCRIPTION="Maven is a software project management and comprehension tool."
SRC_URI="http://dev.gentooexperimental.org/~kiorky/${P}.tar.bz2"
HOMEPAGE="http://maven.apache.org/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEP="=dev-java/plexus-container-default-1.0_alpha9"
DEPEND=">=virtual/jdk-1.4 ${DEP}"
RDEPEND=">=virtual/jre-1.4 ${DEP}"
EANT_GENTOO_CLASSPATH="plexus-container-default-1.0_alpha9"


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
DEP="dev-java/doxia"
DEPEND=">=virtual/jdk-1.4 ${DEP}"
RDEPEND=">=virtual/jre-1.4 ${DEP}"

EANT_GENTOO_CLASSPATH="doxia"



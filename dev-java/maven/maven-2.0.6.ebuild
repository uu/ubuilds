# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="The core of Maven"
LICENSE="Apache-2.0"
HOMEPAGE="http://maven.apache.org"
DEPS="=dev-java/maven-script-${PV}
=dev-java/maven-core-${PV}
"
DEPEND=">=virtual/jdk-1.4 ${DEPS}
source? ( app-arch/zip )"
RDEPEND=">=virtual/jre-1.4 ${DEPS}"
KEYWORDS=""
IUSE="doc source"
SLOT="2"


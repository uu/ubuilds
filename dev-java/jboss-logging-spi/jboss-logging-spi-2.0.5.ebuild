# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="The JBoss Logging Framework Programming Interface."
HOMEPAGE="http://www.jboss.org"
SRC_URI="http://repository.jboss.org/maven2/org/jboss/logging/${PN}/${PV}.GA/${P}.GA-sources.jar"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
		app-arch/unzip"

S="${WORKDIR}"

src_compile() {
	mkdir -p build
	ejavac -d build $(find org/ -name '*.java')
	cd build
	jar -cf "../${PN}.jar" org
}

src_install() {
	java-pkg_dojar "${PN}.jar"
	use source && java-pkg_dosrc org
}


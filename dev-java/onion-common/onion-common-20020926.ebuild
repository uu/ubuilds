# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2

DESCRIPTION="Common package for fec."
HOMEPAGE="http://www.onionnetworks.com/developers/"
SRC_URI="http://www.onionnetworks.com/downloads/fec-1.0.3.zip"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"

S="${WORKDIR}/fec-1.0.3"

src_unpack() {
	unpack ${A}
	cd "${S}"
	unzip -q "common-${PV}.zip"
	cd "common-${PV}"
	sed -i -e 's/build.compiler=jikes/#build.compiler=jikes/g' build.properties

	find "${S}" -iname '*.jar' -delete
	find "${S}" -iname '.class' -delete
}

src_compile() {
	cd "common-${PV}"
	eant clean jars
}

src_install() {
	java-pkg_dojar "common-${PV}/lib/${PN}.jar"
}

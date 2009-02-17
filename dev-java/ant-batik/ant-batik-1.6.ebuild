# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Ant task to rasterize SVG using batik"
HOMEPAGE="http://xmlgraphics.apache.org/batik/tools/rasterizer.html#task"
SRC_URI="mirror://apache/xml/batik/batik-src-${PV}.zip"

LICENSE="Apache-2.0"
BATIK_SLOT="1.6"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ~ppc64 x86"
IUSE=""

COMMON_DEP="dev-java/batik:${BATIK_SLOT}
	dev-java/ant-core"
DEPEND=">=virtual/jdk-1.3
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.3
	${COMMON_DEP}"

S="${WORKDIR}/xml-batik/contrib/rasterizertask"

EANT_GENTOO_CLASSPATH="ant-core batik-${BATIK_SLOT}"
JAVA_ANT_REWRITE_CLASSPATH=1

src_install() {
	java-pkg_dojar build/lib/RasterizerTask.jar
}

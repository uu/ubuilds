# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/laf-plugin/laf-plugin-0.2.ebuild,v 1.1 2007/04/28 22:08:06 caster Exp $

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-ant-2

DESCRIPTION="support for common feel widgets in look-and-feel libraries"
HOMEPAGE="http://${PN}.dev.java.net/"
SRC_URI="https://laf-widget.dev.java.net/files/documents/5097/70070/laf-widget-all.zip"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=virtual/jdk-1.5
	=dev-java/asm-2.2*
	dev-java/ant-core"
RDEPEND=">=virtual/jre-1.5
	=dev-java/asm-2.2*
	dev-java/ant-core"

S="${WORKDIR}/"

src_unpack() {
	unpack ${A}
	rm -rf lib/*.jar drop/*.jar || die
	java-ant_rewrite-classpath
}

src_compile() {
	eant \
		-Djdk.home.java_version_1.5.0=${JAVA_HOME} \
		-Dgentoo.classpath=$(java-pkg_getjar ant-core ant.jar):$(java-pkg_getjar asm-2.2 asm.jar):$(java-pkg_getjar asm-2.2 asm-commons.jar) \
		all
}

src_install() {
	java-pkg_dojar drop/*.jar
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src/org src/contrib/com src/test
	java-pkg_register-ant-task
}

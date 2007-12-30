# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/laf-plugin/laf-plugin-0.2.ebuild,v 1.1 2007/04/28 22:08:06 caster Exp $

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Substance Java look & feel"
HOMEPAGE="http://${PN}.dev.java.net/"
SRC_URI="https://substance.dev.java.net/files/documents/3294/67346/substance-all.zip"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=virtual/jdk-1.5
	dev-java/laf-widget
	dev-java/laf-plugin
	dev-java/jgoodies-forms
	dev-java/swingx"
RDEPEND=">=virtual/jre-1.5
	dev-java/laf-widget
	dev-java/laf-plugin
	dev-java/jgoodies-forms
	dev-java/swingx"

S="${WORKDIR}/"

src_unpack() {
	unpack ${A}
	rm -rf lib/*.jar || die
	epatch ${FILESDIR}/${P}-unjar.patch
	java-ant_rewrite-classpath
}

src_compile() {
	ANT_TASKS="laf-widget" eant \
		-Djdk.home=${JAVA_HOME} \
		-Dgentoo.classpath=$(java-pkg_getjar laf-widget laf-widget.jar):$(java-pkg_getjars laf-plugin,jgoodies-forms,swingx) \
		all
}

src_install() {
	java-pkg_dojar drop/*.jar
	use doc && java-pkg_dojavadoc docs
	#use source && java-pkg_dosrc src/org src/contrib/com src/test
}

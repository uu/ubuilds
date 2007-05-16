# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Java Object Oriented Neural Engine"
HOMEPAGE="http://www.jooneworld.com/"
SRC_URI="mirror://sourceforge/joone/${PN}-src-${PV/_rc/RC}.zip"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="dev-java/velocity dev-java/poi dev-java/xstream dev-java/bsh =dev-java/groovy-1* dev-java/log4j"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.4
	${COMMON_DEPEND}"

S="${WORKDIR}"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	mkdir releases
	rm -rf joone/org/joone/samples || die
	# Fix for http://sourceforge.net/forum/message.php?msg_id=3632500 #
	rm joone/org/joone/net/NestedNeuralLayerBeanInfo.java || die
	rm joone/org/joone/util/SnapshotRecorderBeanInfo.java || die
	###################################################################
	epatch ${FILESDIR}/ioexception.patch
	cd joone
	epatch ${FILESDIR}/jartarget.patch
	cd ..
	mv joone/build.xml . || die
	java-ant_rewrite-classpath
}

src_compile() {
	local gcp=$(java-pkg_getjar velocity velocity.jar):$(java-pkg_getjar poi poi.jar):$(java-pkg_getjars groovy-1,xstream,bsh,log4j)
	eant jar-engine $(use_doc doc) -Dbase=. -Dgentoo.classpath=${gcp}
}

src_install() {
	java-pkg_dojar ${PN}.jar
	use doc && java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc joone/*
}

# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/poi/poi-2.5.1.ebuild,v 1.4 2005/12/16 14:08:33 betelgeuse Exp $

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Set of Java classes that allow you to easily build Java applications that interact with an Asterisk PBX Server. It supports the FastAGI protocol and the Manager API."
HOMEPAGE="http://asterisk-java.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"
IUSE="test"

COMMON_DEPEND="dev-java/log4j"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.4
	dev-java/ant-core
	test? (
		dev-java/ant-tasks
		dev-java/easymock
		=dev-java/junit-3.8*
	)
	${COMMON_DEPEND}"

S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-build.xml.patch

	java-ant_rewrite-classpath
}

src_compile() {
	eant jar $(use_doc) -Dnoget=true -Dgentoo.classpath=$(java-pkg_getjars log4j)
}

src_test() {
	eant test -Dnoget=true -Dgentoo.classpath=$(java-pkg_getjars easymock-1,junit)
}

src_install() {
	java-pkg_newjar target/${P}.jar
	use doc && java-pkg_dojavadoc dist/docs
	use source && java-pkg_dosrc src/java
}

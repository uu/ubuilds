# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/avalon-logkit/avalon-logkit-1.2-r2.ebuild,v 1.6 2007/04/22 18:44:18 caster Exp $

JAVA_PKG_IUSE="doc javamail jms source"
inherit java-pkg-2

DESCRIPTION="An easy-to-use Java logging toolkit designed for secure, performance-oriented logging."
HOMEPAGE="http://avalon.apache.org/"
SRC_URI="http://www.apache.org/dist/avalon/logkit/source/logkit-${PV}-src.tar.gz"
COMMON_DEP="
	=dev-java/avalon-framework-4.1*
	dev-java/sun-jaf
	dev-java/log4j
	=dev-java/servletapi-2.3*
	dev-java/sun-javamail
	dev-java/sun-jms"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

# Doesn't like 1.6 changes to JDBC
DEPEND="|| (
		=virtual/jdk-1.5*
		=virtual/jdk-1.4*
	)
	${COMMON_DEP}"

LICENSE="Apache-1.1"
SLOT="1.2"
KEYWORDS="amd64 ~ia64 ppc ppc64 x86"

S="${WORKDIR}/logkit-${PV}-dev"
SRC_DIR="${S}/src/java"
JAVADOC_DIR="${S}/javadoc"

src_compile() {
	mkdir classes || die "Could not create compile output dir"
	ejavac -cp $(java-pkg_getjars sun-jaf,sun-javamail,sun-jms,log4j,servletapi-2.3,avalon-framework-4.1) -d classes $(find ${SRC_DIR} -name "*.java") || die "Compilation failed"
	jar -cf "${S}/${PN}.jar" -C classes . || die "Could not create jar"
	#Generate javadoc
	if use doc ; then
		mkdir "${JAVADOC_DIR}" || die "Could not create javadoc dir"
		cd ${SRC_DIR}
		javadoc -source "${JAVA_VERSION}" -d ${JAVADOC_DIR} $(find "net/infonode" -type d | tr '/' '.') || die "Could not create javadoc"
	fi
}

src_install() {
	java-pkg_dojar ${PN}.jar
	use doc && java-pkg_dojavadoc ${JAVADOC_DIR}
	use source && java-pkg_dosrc ${SRC_DIR}/*
}

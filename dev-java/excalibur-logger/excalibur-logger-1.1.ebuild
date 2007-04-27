# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2

DESCRIPTION="Logger from the Excalibur containerkit"
HOMEPAGE="http://excalibur.apache.org/logger.html"
SRC_URI="mirror://apache/avalon/${PN}/source/${P}.zip"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~amd64 ~x86"

JAVA_VERSION="1.4"
COMMON_DEPEND="=dev-java/avalon-framework-4.1*
	~dev-java/avalon-logkit-1.2.2
	dev-java/log4j
	=dev-java/servletapi-2.3*
	dev-java/sun-jms
	dev-java/sun-javamail
	dev-java/excalibur-i18n"

RDEPEND=">=virtual/jre-${JAVA_VERSION}
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-${JAVA_VERSION}
	app-arch/unzip
	${COMMON_DEPEND}"
SRC_DIR="${S}/src/java"
JAVADOC_DIR="${S}/javadoc"

src_compile() {
	built_with_use --hidden dev-java/avalon-logkit javamail jms
	local modules="api impl log4j logkit servletlogger"
	for module in ${modules}; do
		cp -R ${S}/${module}/src/java/* ${SRC_DIR}
	done
	mkdir classes || die "Could not create compile output dir"
	ejavac -cp $(java-pkg_getjars avalon-logkit-1.2,avalon-framework-4.1,log4j,servletapi-2.3,sun-jms,sun-javamail,excalibur-i18n) -d classes $(find ${SRC_DIR} -name "*.java") || die "Compilation failed"
	jar -cf "${S}/${PN}.jar" -C classes . || die "Could not create jar"
	#Generate javadoc
	if use doc ; then
		mkdir "${JAVADOC_DIR}" || die "Could not create javadoc dir"
		cd ${SRC_DIR}
		javadoc -source "${JAVA_VERSION}" -d ${JAVADOC_DIR} $(find "org/apache/avalon/excalibur/logger" -type d | tr '/' '.') || die "Could not create javadoc"
	fi
}

src_install() {
	java-pkg_dojar ${PN}.jar
	use doc && java-pkg_dojavadoc ${JAVADOC_DIR}
	use source && java-pkg_dosrc ${SRC_DIR}/*
}

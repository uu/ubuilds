# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Refactored Amazon S3 REST library to use the Apache HTTP client
library"
HOMEPAGE="http://e-xml.sourceforge.net/"
SRC_URI="${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

COMMON_DEP="dev-java/e-xml
			dev-java/commons-httpclient:3
			dev-java/commons-logging
			dev-java/commons-codec
			java-virtuals/servlet-api:2.3"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	test? (
		dev-java/junit:0
		dev-java/ant-junit
	)
	${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	java-ant_rewrite-classpath
}

EANT_BUILD_TARGET="package"
EANT_DOC_TARGET="javadoc"
EANT_GENTOO_CLASSPATH="e-xml,commons-httpclient-3,commons-logging,commons-codec,servlet-api-2.3"

src_test() {
	local cp="-Dgentoo.classpath=$(java-pkg_getjars ${EANT_GENTOO_CLASSPATH},junit)"
	ANT_TASKS="ant-junit" eant "${cp}" test
}

src_install() {
	java-pkg_newjar "target/${P}.jar"
	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/*
}


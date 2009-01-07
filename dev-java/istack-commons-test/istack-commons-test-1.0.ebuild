# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"
GROUP_ID="com.sun.istack"

inherit java-pkg-2 java-mvn-src

DESCRIPTION="Common test-related utility code for the istack components"
HOMEPAGE="https://istack-commons.dev.java.net/"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~x86"

COMMON_DEP="dev-java/junit
	dev-java/dom4j
	dev-java/ant-junit"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
JAVA_GENTOO_CLASSPATH="junit dom4j-1 ant-junit ant-core"

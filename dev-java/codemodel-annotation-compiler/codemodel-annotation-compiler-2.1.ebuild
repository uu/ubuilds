# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

JAVA_PKG_IUSE="doc source"
GROUP_ID="com.sun.codemodel"

inherit java-pkg-2 java-mvn-src

DESCRIPTION="The annotation compiler ant task for the CodeModel java source code generation library"
HOMEPAGE="https://codemodel.dev.java.net/"

LICENSE="CDDL"
SLOT="2"
KEYWORDS="~amd64 ~x86 ~ia64 ~ppc ~x86-fbsd"

COMMON_DEP=""
DEPEND=">=virtual/jdk-1.5
	dev-java/codemodel:2
	dev-java/ant-core
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
JAVA_GENTOO_CLASSPATH="codemodel-2 ant-core"

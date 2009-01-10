# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE=""
GROUP_ID="org.freehep"
MAVEN2_REPOSITORIES="http://java.freehep.org/maven2"

inherit java-pkg-2 java-mvn-src

DESCRIPTION="High Energy Physics Java library - FreeHEP ROOT IO Reader and Writer"
HOMEPAGE="http://java.freehep.org/"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND=">=dev-java/bcel-5.2
	dev-java/freehep-misc-deps
	>=dev-java/junit-3.8.2"
DEPEND=">=virtual/jdk-1.5
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
JAVA_GENTOO_CLASSPATH="bcel,freehep-misc-deps,junit"

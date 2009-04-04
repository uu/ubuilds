# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 subversion

DESCRIPTION="Timer and Work Manager"
HOMEPAGE="http://vmgump.apache.org/gump/public/commonj/commonj/index.html"
ESVN_REPO_URI="http://svn.apache.org/repos/asf/webservices/archive/wsrf/trunk/commonj-twm"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4"

src_compile() {
	ejavac -d . `find src/java/ -type f -name \*.java -print0 | xargs --null`
	jar cf "${PN}.jar" commonj || die
	use doc && javadoc -quiet -d docs -sourcepath src/java \
		-subpackages commonj.work commonj.timers
}

src_install() {
	java-pkg_dojar "${PN}.jar"
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src/java/*
}

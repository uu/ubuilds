# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="SvnAnt is an ant task that provides an interface to Subversion revision control system"

# To recreate tarball do the following:
#
# 1. svn export http://subclipse.tigris.org/svn/subclipse/trunk/svnant/ 
# 2. Rename the directory svnant to svnant-1.1.0_rc2_pre3198, and tar & bzip2
#
# For convenience I am also supplying a tarball on my personal server.

SRC_URI="http://www.elvanor.net/gentoo/${P}.tar.bz2"


HOMEPAGE="http://subclipse.tigris.org/svnant.html"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64"

CDEPEND="dev-util/svnclientadapter"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.4
	>=dev-java/ant-core-1.7.0"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.4"

IUSE=""

#S="${WORKDIR}/svnant-1.1.0-RC2/"

src_unpack() {
	unpack ${A}
	cd "${S}"
	java-ant_rewrite-classpath

	cd "${S}"
	rm -rf lib/
}

src_compile() {
	ANT_TASKS="ant-nodeps"

	eant -Dgentoo.classpath="$(java-pkg_getjars ant-core,svnclientadapter)"
}

src_install() {
	use source && java-pkg_dosrc src/main/org
	java-pkg_newjar "build/lib/${PN}.jar"
	java-pkg_register-ant-task
}

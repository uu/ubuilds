# Copyright 1999-2007 Gentoo Foundation
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

SRC_URI="${P}.tar.bz2"

HOMEPAGE="http://subclipse.tigris.org/svnant.html"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RDEPEND=">=virtual/jre-1.4
		>=dev-java/ant-core-1.7.0
		dev-util/svnclientadapter"

DEPEND=">=virtual/jdk-1.4
	dev-util/svnclientadapter"

IUSE=""

#S="${WORKDIR}/svnant-1.1.0-RC2/"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	java-ant_rewrite-classpath

	cd "${S}"
	rm -rf lib/
}

src_compile() {

	ANT_TASKS="ant-tasks"

	cd "${S}"
	
	eant -Dgentoo.classpath="$(java-pkg_getjars ant-core,svnclientadapter)"
}

src_install() {
	java-pkg_newjar build/lib/svnant.jar
	java-pkg_register-ant-task
}

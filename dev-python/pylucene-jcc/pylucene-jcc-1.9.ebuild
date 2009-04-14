# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
NEED_PYTHON=2.5

inherit versionator java-pkg-2 python distutils

# The JCC sources are included in pylucene's sources, which have a different
# version. This has to be changed with each major version bump!
PYLUCENE_PN="PyLucene"
PYLUCENE_PV="2.3.2-1"
PYLUCENE_P="${PYLUCENE_PN}-${PYLUCENE_PV}"

DESCRIPTION="a C++ code generator for calling Java from C++/Python"
HOMEPAGE="http://lucene.apache.org/pylucene/jcc/index.html"
SRC_URI="http://downloads.osafoundation.org/${PYLUCENE_PN}/jcc/${PYLUCENE_P}-src-jcc.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
# Note: yes JCC uses setuptools at runtime - that's a vital part of what JCC
# does. Generate, Build, and Install Python Modules. And yes, it needs jdk at
# runtime as well, because it uses jni.h and other jdk libraries as it builds
# the java parts of the python modules.
DEPEND=">=dev-python/setuptools-0.6_rc7
	>=virtual/jdk-1.4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PYLUCENE_P}/jcc"

DOCS="README CHANGES DESCRIPTION INSTALL"

pkg_setup () {
	# These JCC_* variables are used internally within setup.py script to
	# override the defaults that they use to compile the C++ parts including
	# linking against the JDK. If you think it's ugly, sorry, it's a lot better
	# than a big ugly hairy patch to include a different variable like JCC_JDK
	if use amd64; then
		JCC_LFLAGS="-L${JAVA_HOME}/jre/lib/amd64 -ljava"
		JCC_LFLAGS="${JCC_LFLAGS} -L${JAVA_HOME}/jre/lib/amd64/server -ljvm"
		JCC_LFLAGS="${JCC_LFLAGS} -Wl,-rpath=${JAVA_HOME}/jre/lib/amd64:${JAVA_HOME}/jre/lib/i386/server"
	else
		JCC_LFLAGS="-L${JAVA_HOME}/jre/lib/i386 -ljava"
		JCC_LFLAGS="${JCC_LFLAGS} -L${JAVA_HOME}/jre/lib/i386/client -ljvm"
		JCC_LFLAGS="${JCC_LFLAGS} -Wl,-rpath=${JAVA_HOME}/jre/lib/i386:${JAVA_HOME}/jre/lib/i386/client"
	fi
	export JCC_LFLAGS
	export JCC_ARGSEP=" "
	local jcci="$(java-pkg_get-jni-cflags)"
	export JCC_INCLUDES="${jcci//-I/}"
	# Note for future reference: Other variables that can and might need to be
	# changed at some point include: JCC_CFLAGS

	java-pkg-2_pkg_setup
}

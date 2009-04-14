# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
NEED_PYTHON=2.5
JAVA_PKG_IUSE="source doc"

inherit versionator java-pkg-2 python distutils

# The JCC sources are included in pylucene's sources, which have a different
# version. This has to be changed with each major version bump!
PYLUCENE_PN="pylucene"
PYLUCENE_PV="2.4.1-1"
PYLUCENE_P="${PYLUCENE_PN}-${PYLUCENE_PV}"

DESCRIPTION="a C++ code generator for calling Java from C++/Python"
HOMEPAGE="http://lucene.apache.org/pylucene/jcc/index.html"
SRC_URI="http://apache.promopeddler.com/lucene/${PYLUCENE_PN}/${PYLUCENE_P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug"
# Note: yes JCC uses setuptools at runtime - that's a vital part of what JCC
# does. Generate, Build, and Install Python Modules. And yes, it needs jdk at
# runtime as well, because it uses jni.h and other jdk libraries as it builds
# the java parts of the python modules.
DEPEND=">=dev-python/setuptools-0.6_rc9-r1
	>=virtual/jdk-1.4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PYLUCENE_P}/jcc"

DOCS="README CHANGES DESCRIPTION NOTICE"

# FIXME Needs a patch applied to setuptools (issue 43) Bug#259591

pkg_setup () {
	# The Pylucene devs opted to compile all their java parts from within a
	# setuptools setup.py script. These JCC_* variables are used internally
	# within that setup.py script to override the defaults that they use to
	# compile the Java and C++ parts.
	export JCC_JDK="${JAVA_HOME}"
	export JCC_ARGSEP=" "
	local jcci="$(java-pkg_get-jni-cflags)"
	export JCC_INCLUDES="${jcci//-I/}"
	export JCC_JAVAC="${JAVAC} $(java-pkg_javac-args)"
	# Note for future reference: Other variables that can and might need to be
	# changed at some point include: JCC_CFLAGS JCC_DEBUG_CLFAGS JCC_LFLAGS

	# We need to get setuptools patched with patches/patch.43 to be able to
	# compile this right. NO_SHARED disables the check for such a patch.
	# Bug#29591
	#elog "Setuptools does not have the sharedlib patch, so compiling as a shared library has been disabled!"
	#export NO_SHARED=1

	java-pkg-2_pkg_setup
}

src_compile() {
	# Though this does not create any jars, when setuptools has the above
	# mentioned sharedlib patch, then this will compile some java classes, which
	# will be placed in the python module (not in a jar). This should take care
	# of any possible dependencies.
	java-pkg_addcp "$(python_get_sitedir)"/jcc/classes

	distutils_src_compile $(use debug && echo --debug)
	
	if use doc; then
		mkdir docs || die "Making docs directory failed!"
		javadoc -package -subpackages org.* -d docs -version -author -use \
			-windowtitle "${P} API" $(ls java/org/apache/jcc/*.java) \
			|| die "Javadoc failed to make the docs!"
	fi
}

src_install() {
	distutils_src_install

	use source && java-pkg_dosrc "${S}"/java
	if use doc; then
		java-pkg_dojavadoc docs
		# Note, there's no good way to separate the jcc docs from pylucene, so
		# we'll just have to deal with pylucene and pylucene-jcc having
		# duplicate docs. If there are any other suggestions, I'm open.
		dohtml -r ../doc/*
	fi
}

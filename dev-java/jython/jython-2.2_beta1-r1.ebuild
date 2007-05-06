# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="readline source doc servlet"
#jdnc,  mysql oracle, postgresql

inherit base java-pkg-2 java-ant-2

DESCRIPTION="An implementation of Python written in Java"
HOMEPAGE="http://www.jython.org"

MY_PV="installer-2.2b1"
PYVER="2.2.3"
SRC_URI="http://www.python.org/ftp/python/${PYVER%_*}/Python-${PYVER}.tgz
	  mirror://sourceforge/${PN}/${PN}_${MY_PV}.jar"

LICENSE="JPython"
SLOT="0"
KEYWORDS=""
IUSE=""
# servlet

CDEPEND="=dev-java/jakarta-oro-2.0*
	readline? ( >=dev-java/libreadline-java-0.8.0 )
	servlet? ( ~dev-java/servletapi-2.4 )"
RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.4
	${CDEPEND}"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	mv build.xml build.xml.orig
	sed 's/name="javadoc" if="full-build"/name="javadoc"/' \
	build.xml.orig > build.xml

	echo javacc.jar="$(java-pkg_getjars javacc)" > ant.properties
	#echo "python.lib=${pylib}" >> ant.properties
	if use readline; then
		echo "readline.jar=$(java-pkg_getjars libreadline-java)" >> \
		ant.properties
	fi
	if use servlet; then
		echo "servlet.jar=$(java-pkg_getjar servlet-2.4 servlet.jar)" \
		>> ant.properties
	fi
}


src_compile() {

	local antflags="-Dbase.path=src/java -Dsource.dir=src/java/src"
	local pylib="Python-${PYVER}/Lib"
	antflags="${antflags} -Dpython.lib=${pylib}"
	LC_ALL=C eant ${antflags} developer-build $(use_doc javadoc)
	#LC_ALL=C eant ${antflags} -Ddo.checkout=false full-build
}

src_install() {
	java-pkg_dojar "dist/${PN}.jar"

	dodoc README.txt NEWS ACKNOWLEDGMENTS
	use doc && dohtml -A .css .jpg .gif -r Doc/*

	java-pkg_dolauncher jythonc \
						--main "org.python.util.jython" \
						--java_args "-Dpython.home=/usr/share/jython "\
						"-Dpython.cachedir=\${HOME}/.jython/cachedir" \
						--pkg_args "/usr/share/jython/tools/jythonc/jythonc.py"

	java-pkg_dolauncher jython \
						--main "org.python.util.jython" \
						--java_args "-Dpython.home=/usr/share/jython  \
						-Dpython.cachedir=\${HOME}/.jython/cachedir"

	dodir /usr/share/jython/cachedir
	chmod a+rw ${D}/usr/share/jython/cachedir

	#rm Demo/jreload/example.jar
	insinto /usr/share/${PN}
	doins -r dist/Lib registry

	insinto /usr/share/${PN}/tools
	doins -r dist/Tools/*

	use source && java-pkg_dosrc src
}

pkg_postinst() {
	if use readline; then
		elog "To use readline you need to add the following to your registry"
		elog
		elog "python.console=org.python.util.ReadlineConsole"
		elog "python.console.readlinelib=GnuReadline"
		elog
		elog "The global registry can be found in /usr/share/${PN}/registry"
		elog "User registry in \$HOME/.jython"
		elog "See http://www.jython.org/docs/registry.html for more information"
		elog ""
	fi

	elog "This revision renames org.python.core.Py.assert to assert_."
	elog "This is the solution that upstream will use in the next release."
	elog "Just note that this revision is not API compatible with vanilla 2.1."
	elog "https://bugs.gentoo.org/show_bug.cgi?id=142099"
}

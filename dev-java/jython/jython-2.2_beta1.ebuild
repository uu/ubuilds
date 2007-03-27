# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="readline source doc servlet"
#jdnc,  mysql oracle, postgresql

inherit base java-pkg-2 java-ant-2

DESCRIPTION="An implementation of Python written in Java"
HOMEPAGE="http://www.jython.org"

SRC_URI="${P}.tar.bz2"
LICENSE="JPython"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""
# servlet

CDEPEND="=dev-java/jakarta-oro-2.0*
	readline? ( >=dev-java/libreadline-java-0.8.0 )
	servlet? ( ~dev-java/servletapi-2.4 )"
RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.4
	${CDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	#epatch ${FILESDIR}/${PV}-assert.patch
	#epatch ${FILESDIR}/${PV}-assert-SimpleCompiler.py.patch

	# bug #160861
	#rm -rf org/apache

	echo javaccHome="$(java-pkg_getjars javacc)" > ant.properties
	echo "python.home=/usr/lib/python2.4/" >> ant.properties
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
	LC_ALL=C eant developer-build $(use_doc javadoc)
}

src_install() {
	java-pkg_dojar "dist/${PN}.jar"

	dodoc README.txt NEWS ACKNOWLEDGMENTS
	use doc && dohtml -A .css .jpg .gif -r Doc/*

	java-pkg_dolauncher jythonc \
						--main "org.python.util.jython" \
						--java_args "-Dpython.home=/usr/share/jython \
						-Dpython.cachedir=\$\{HOME\}/.jython/cachedir" \
						--pkg_args "/usr/share/jython/tools/jythonc/jythonc.py"

	java-pkg_dolauncher jython \
						--main "org.python.util.jython" \
						--java_args "-Dpython.home=/usr/share/jython  \
						-Dpython.cachedir=\$\{HOME\}/.jython/cachedir"

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

# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A seemless extension to the Java programming language for Aspect Oriented Programming (AOP)"

# How to create the tarball:
#
# cvs -d:pserver:anonymous@dev.eclipse.org:/cvsroot/tools/ export -r V1_5_3_final org.aspectj/modules
#
# Remove inside the lib/ directory everything except build/, bcel/, ext/ and aspectj/ subdirectories
# This saves about 13 MB in the tarball.
#
# Note that for convenience I am also providing a prebuilt tarball on my personal server.

# Notes so far:
#
# We keep the lib/build directory as it may contain build.jar, a jar needed for bootstrapping.
# We also use some bundled AspectJ libraries for building, probably needed for boostrapping.
# We use the bundled BCEL jar (/lib/bcel) as it is a modified version of vanilla Apache BCEL, with lots of improvements/fixes.
# If need be, we could try to build it, source is present in bcel-builder/.
# We also use the very small Jrockit bundled jar file. Maybe we could extract it from JRockit but this is probably not worth it.
#
# The output of the build system is in the aj-build directory. Do not take the main jar (dist/aspectj-1.5.3-gentoo.jar) from there.
# This jar contains docs and all so we better install the jars in dist/tools/lib/

# Possible improvements:
#
# USE flags (for Eclipse, etc...)
# Make this package build with a 1.4 JVM


SRC_URI="http://www.elvanor.net/gentoo/${P}.tar.bz2"
HOMEPAGE="http://www.eclipse.org/aspectj/"

CDEPEND="dev-java/bcel
	dev-java/junit
	dev-java/jython
	>=dev-java/jakarta-regexp-1.4
	=dev-java/saxon-6.5*
	dev-java/commons-logging
	dev-java/jdiff
	dev-java/ant-junit"

DEPEND=">=virtual/jdk-1.5
	sys-apps/findutils
	=app-text/docbook-xml-dtd-4.1.2*
	app-text/docbook-xsl-stylesheets
	>=dev-java/xml-commons-external-1.3
	>=dev-java/xerces-2.8.1
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

SLOT="1.5"
LICENSE="CPL-1.0 Apache-1.1"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

S="${WORKDIR}/${P}/modules"

src_unpack() {
	unpack ${A}
	cd "${S}"

	cd build
	# FIXME : Broken so wrapping in use flag as no time to fix
	if ! use doc; then
		sed -i -e "s/aspectjtools-dist,docs-dist/aspectjtools-dist/g" build.xml || die "sed failed"
		sed -i -e "/aj.dist.dir}\/docs/d" build.xml || die "sed failed"
		sed -i -e "s/do-rt,do-source,do-ajde,do-doc/do-rt,do-source,do-ajde/g" ../eclipse.plugin/build.xml || die "sed failed"
	fi

	java-ant_rewrite-classpath
	cp "${FILESDIR}/${P}-local.properties" local.properties

	cd "${S}/lib" && mkdir junit && cd junit
	java-pkg_jar-from junit
	java-pkg_jar-from ant-junit

	cd "${S}/lib" && mkdir ant && mkdir ant/lib && cd ant/lib
	java-pkg_jar-from --build-only ant-core
	java-pkg_jar-from --build-only xml-commons-external-1.3
	java-pkg_jar-from --build-only xerces-2

	cd "${S}/lib" && mkdir commons && cd commons
	java-pkg_jarfrom commons-logging commons-logging.jar commons.jar

	cd "${S}/lib" && mkdir regexp && cd regexp
	java-pkg_jarfrom jakarta-regexp-1.4

	cd "${S}/lib" && mkdir jdiff && cd jdiff
	java-pkg_jarfrom jdiff

	cd "${S}/lib" && mkdir saxon && cd saxon
	java-pkg_jarfrom saxon-6.5

	if use doc; then
	cd "${S}/lib" && mkdir docbook && cd docbook

	# Here we hardcode the location of docbook-xml-dtd and semi hardcode the location of docbook-xsl-stylesheets
	docbookXslLocation="$(best_version app-text/docbook-xsl-stylesheets | sed 's,app-text/docbook-,,')"
	einfo "${docbookXslLocation}"
	ln -s "/usr/share/sgml/docbook/${docbookXslLocation}" docbook-xsl || die "Failed to create docbook symlink"
	ln -s "/usr/sharie/sgml/docbook/xml-dtd-4.1.2" docbook-dtd || die "Failed to create docbook symlink"
	fi
}

src_compile() {
	cd "${S}/build"
	ANT_TASKS="ant-junit" eant
}

src_install() {
	java-pkg_dojar aj-build/dist/tools/lib/*.jar
	java-pkg_dolauncher ajc --main org.aspectj.tools.ajc.Main
	java-pkg_dolauncher ajbrowser --main org.aspectj.tools.ajbrowser.Main
	if use doc; then
		dohtml aj-build/dist/docs/doc/*.html
		dohtml aj-build/dist/docs/README-AspectJ.html
		cp -R aj-build/dist/docs/doc/{devguide,aspectj5rt-api,progguide} "${D}/usr/share/doc/${P}/html"
		cp -R aj-build/dist/docs/doc/examples "${D}/usr/share/doc/${P}/examples"
		cp aj-build/dist/docs/doc/*.pdf "${D}/usr/share/doc/${P}"
	fi
}

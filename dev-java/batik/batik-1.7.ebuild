# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI=1

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Java based SVG toolkit"
HOMEPAGE="http://xml.apache.org/batik/"
SRC_URI="mirror://apache/xmlgraphics/${PN}/${PN}-src-${PV}.zip"

LICENSE="Apache-2.0"
SLOT="1.7"
KEYWORDS="amd64 ~ia64 ppc ~ppc64 ~x86"
IUSE="doc python tcl"

CDEPEND="
	dev-java/rhino:1.6
	dev-java/xerces:2
	dev-java/xml-commons-external
	dev-java/xalan
	python? ( dev-java/jython )
	tcl? ( dev-java/jacl )"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	cd lib
	rm -v *.jar build/*.jar || die

	java-pkg_jar-from xml-commons-external-1.3
	java-pkg_jar-from xalan
	java-pkg_jar-from xerces-2
	# Can't make rhino optional because
	# apps/svgbrowser needs it

	java-pkg_jar-from rhino-1.6
	use python && java-pkg_jar-from jython
	use tcl && java-pkg_jar-from jacl
}

JAVA_ANT_IGNORE_SYSTEM_CLASSES="true"
EANT_BUILD_TARGET="all-jar"

src_compile() {
	# Fails to build on amd64 without this
	if use amd64 ; then
		export ANT_OPTS="-Xmx1g"
	else
		export ANT_OPTS="-Xmx256m"
	fi

	java-pkg-2_src_compile
}

src_install() {
	java-pkg_dojar ${P}/lib/batik-all.jar

	dodoc README || die "dodoc failed"
	use doc && java-pkg_dojavadoc ${P}/docs/javadoc

	# pwd fixes bug #116976
	java-pkg_dolauncher batik-${SLOT} --pwd "/usr/share/${PN}-${SLOT}/" \
		--main org.apache.batik.apps.svgbrowser.Main

	# To find these lsjar batik-${SLOT} | grep Main.class
	# Using a security manager would require write permission
	for launcher in ttf2svg slideshow svgpp rasterizer; do
		java-pkg_dolauncher batik-${launcher}-${SLOT} \
			--pkg_args "-scriptSecurityOff" \
			--main org.apache.batik.apps.${launcher}.Main
	done
}

pkg_postinst() {
	elog "Wrappers execute batik with -scriptSecurityOff because otherwise"
	elog "we get java.security.AccessControlException: access denied."
	elog "Feel free to submit a fix to http://bugs.gentoo.org if you come"
	elog "up with one."
}

# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# The test are disabled, partially because the jaxb-api ebuilds are broken
# (see bug #278883) and partially because the VM selection process doesn't
# take account of the fact that the JRE is sometimes needed at build time
# when running tests. It is also needed when using the ant tasks provided
# by this package. Trying to work around this by explicitly giving the
# dependencies in this ebuild also seems to confuse the process. :(

# As it happens, the always_create_dirs_(on|off) tests fail anyway and I
# haven't been able to work out why. The ant process also returns successfully
# even if the tests fail. Not good.

EAPI="2"
JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-ant-2

MY_P="${PN}_${PV}"

DESCRIPTION="Text file preprocessor tool that uses FreeMarker templates"
HOMEPAGE="http://fmpp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

CDEPEND="dev-java/bsh
	dev-java/xml-commons-resolver
	dev-java/jakarta-oro:2.0
	dev-java/freemarker:2.3"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.4"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.4"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="bsh xml-commons-resolver jakarta-oro-2.0 freemarker-2.3"
S="${WORKDIR}/${MY_P}"

java_prepare() {
	# Remove bundled stuff.
	rm -vf lib/*.jar lib/forbuild/*.jar || die

	# Rename this file so we can build it.
	mv -f lib/forbuild/classes/imageinfo/Imageinfo.java.dontcheck \
		lib/forbuild/classes/imageinfo/ImageInfo.java || die

	# Fix classpath when running tests.
	sed -i 's:${xpathSupport.lib}:${gentoo.classpath}:g' build.xml || die
}

src_compile() {
	ejavac lib/forbuild/classes/imageinfo/ImageInfo.java
	eant jar
}

src_install() {
	java-pkg_dojar lib/${PN}.jar
	java-pkg_dolauncher ${PN} --main fmpp.tools.CommandLine

	dodoc README.txt TODO.txt || die
	use source && java-pkg_dosrc src/java/*

	if use doc; then
		dohtml -r docs/*.html docs/img || die
		java-pkg_dojavadoc docs/api
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r docs/examples || die
	fi
}

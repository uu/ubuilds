# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2

DESCRIPTION="Compatibility was a library consisting of several utility classes."
HOMEPAGE="http://excalibur.apache.org/deprecation.html"
SRC_URI="mirror://apache/excalibur/${PN}/source/${P}.zip"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""


RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
		app-arch/unzip"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -vrf docs *.jar
	unzip -qq src.zip
}

src_compile() {
	mkdir -p classes javadoc || die "Unable to make build dirs"

	ejavac -d classes $(find ${SRC_DIR} -name "*.java") || die "Compilation failed"
	jar -cf "${S}/${PN}.jar" -C classes . || die "Could not create jar"
	#Generate javadoc
	if use doc ; then
		javadoc -source "$(java-pkg_get-source)" -d javadoc $(find "org/apache/avalon/excalibur" -type d | tr '/' '.') || die "Could not create javadoc"
	fi

}

src_install() {
	java-pkg_dojar "${PN}.jar"
	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc org
}


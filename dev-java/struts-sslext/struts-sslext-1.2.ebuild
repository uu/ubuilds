# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2

DESCRIPTION="Extension to Struts that allows automatically switching between http and https."
HOMEPAGE="http://sslext.sourceforge.net"
SRC_URI="mirror://sourceforge/sslext/sslext-struts${PV}-src.zip"

LICENSE="Apache-2.0"
SLOT="1.2"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEP="
	dev-java/commons-logging:0
	dev-java/commons-digester:0
	dev-java/servletapi:2.4
	dev-java/struts:1.3"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"

src_unpack() {
	mkdir -p "${S}/src"
	cd "${S}/src/" || die
	unpack ${A}
}

src_prepare() {
	# enum is keyword in java 5 or newer
	epatch "${FILESDIR}/java5plus.patch"

	mkdir classes lib && cd lib/ || die
	java-pkg_jar-from commons-digester
	java-pkg_jar-from commons-logging commons-logging-api.jar
	java-pkg_jar-from servletapi-2.4
	java-pkg_jar-from struts-1.3 struts-core.jar
	java-pkg_jar-from struts-1.3 struts-taglib.jar
	java-pkg_jar-from struts-1.3 struts-tiles.jar
}

src_compile() {
	ejavac -d classes -cp `find lib/ -name \*.jar -printf "%p:"` \
		`find src/ -type f -name \*.java -print0 | xargs --null`
	jar cf "${PN}.jar" -C classes . || die
	use doc && javadoc -d docs -sourcepath src \
		-classpath `find lib/ -name \*.jar -printf "%p:"` \
		-subpackages org.apache.struts.action org.apache.struts.config \
		org.apache.struts.taglib.html org.apache.struts.tiles \
		org.apache.struts.util test.ssl
}

src_install() {
	java-pkg_dojar "${PN}.jar"
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src/*
}


# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

JAVA_PKG_IUSE="source mapper"

inherit java-pkg-2 java-ant-2

DESCRIPTION="High-performance JSON processor."
HOMEPAGE="http://jackson.codehaus.org/"
SRC_URI="http://jackson.codehaus.org/1.4.4/jackson-src-1.4.4.tar.gz"

LICENSE="|| ( Apache-2.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

COMMON_DEP="mapper? ( dev-java/joda-time:0 )"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

S="${WORKDIR}/${PN}-src-${PV}"

#TODO Finish this ebuild 2 more jars to package

src_prepare() {
	java-pkg-2_src_prepare
	find lib/{cobertura,ext,jaxb,jaxrs,perf} -iname '*.jar' -delete

	#lib/ext/joda-time-1.5.2.jar
	use mapper && java-pkg_jar-from --into lib/ext joda-time joda-time.jar
}

src_compile() {
	local targets="jar.core.asl"
	use mapper && targets="${targets} jar.mapper.asl"
	eant ${targets}
}

src_install() {
	cd build || die
	java-pkg_newjar "${PN}-core-asl-${PV}.jar" "${PN}-core.jar"
	use mapper && java-pkg_newjar "${PN}-mapper-asl-${PV}.jar" \
		"${PN}-mapper.jar"

	#use doc && java-pkg_dojavadoc build/javadoc
	use source && java-pkg_dosrc src
}

# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2 eutils

MY_P="k5n-all-src-${PV}"

DESCRIPTION="A java implementation of RFC 2445 (ical) recurrence rules"
HOMEPAGE="http://google-rfc-2445.googlecode.com/"
SRC_URI="http://dev.gentoo.org/~serkan/distfiles/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

COMMON_DEP="dev-java/joda-time:0"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	test? (
		dev-java/junit:0
		dev-java/ant-junit
	)
	${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	epatch "${FILESDIR}"/${P}-build.xml.patch
	cd third_party/joda-time || die
	java-pkg_jar-from joda-time joda-time.jar
	if use test; then
		mkdir -p "${S}"/third_party/junit || die
		cd "${S}"/third_party/junit || die
		java-pkg_jar-from --build-only junit junit.jar
	fi
}

EANT_BUILD_TARGET="rfc2445"
EANT_DOC_TARGET="docs"

src_test() {
	ANT_TASKS="ant-junit" eant runtests
}

src_install() {
	java-pkg_dojar jars/${PN}.jar
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src/com
}


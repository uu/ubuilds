# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Flexible Calendar component to the Java Platform"
HOMEPAGE="http://nachocalendar.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	test? ( dev-java/junit )"
EANT_BUILD_TARGET="jar"
EANT_DOC_TARGET="javadoc"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	rm -rf doc || die
	rm -f lib/* || die
}

src_install() {
	java-pkg_newjar lib/${P}.jar ${PN}.jar
	java-pkg_newjar lib/${P}-demo.jar ${PN}-demo.jar
	java-pkg_dolauncher nachocalendar-demo --main net.sf.nachocalendar.demo.CalendarDemo
	dodoc *.txt
	use doc && java-pkg_dojavadoc doc
	insinto /usr/share/doc/${PF}
	use doc && newins manual-${PV}.pdf manual.pdf
	use source && java-pkg_dosrc src/java/*
}

src_test() {
	cd src/test
	ejavac -cp \
		"${S}/lib/${P}.jar:$(java-pkg_getjars --build-only junit)" \
		./net/sf/nachocalendar/model/DefaultDataModelTest.java
	ejavac -cp \
		"${S}/lib/${P}.jar:$(java-pkg_getjars --build-only junit)" \
		./net/sf/nachocalendar/model/DefaultDateSelectionModelTest.java
	ejunit -cp ".:${S}/lib/${P}.jar" \
		net.sf.nachocalendar.model.DefaultDataModelTest \
		net.sf.nachocalendar.model.DefaultDateSelectionModelTest
}

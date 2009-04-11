# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="The Google Data APIs (GData) provide a simple protocol for reading and writing data on the web."
HOMEPAGE="http://gdata-java-client.googlecode.com/"
SRC_URI="http://${PN}-java-client.googlecode.com/files/${PN}-src.java-${PV}.java.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

COMMON_DEP="java-virtuals/jaf
		java-virtuals/javamail
		java-virtuals/jdk-with-com-sun"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"

PATCHES=( ${FILESDIR}/gdata.core.build.patch )

S="${WORKDIR}/${PN}/java"

src_prepare() {
	epatch ${PATCHES}

	find . -iname '*.jar' -delete

	cd build-src || die
	(
		echo "mail.jar=$(java-pkg_getjar javamail mail.jar)"
		echo "activation.jar=$(java-pkg_getjars jaf)"
		echo "javac.debug=true"
		echo "javac.debuglevel=lines,vars,source"

	) > build.properties

	java-ant_bsfix_files *.xml
	cd .. || die
	ln -s $(java-config --tools) tools.jar
}

EANT_BUILD_XML="build-src.xml"
EANT_BUILD_TARGET="all"

src_install() {

	cd lib
	for file in $(find . -iname '*.jar'); do
		 java-pkg_newjar "${file}" "$(echo $file | sed -e 's_./__g' | sed -e 's/-[0-9]\.[0-9]//g')"
	done

	cd "${S}"
	#use doc && java-pkg_dojavadoc doc
	use source && java-pkg_dosrc src/*
}


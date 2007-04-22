# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-utils-2

DESCRIPTION="An open platform for simply browsing and research on the Holy Quran"
HOMEPAGE="http://siahe.com/zekr/"
SRC_URI="mirror://sourceforge/${PN}/${P}-linux.tar.gz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4
	 dev-java/commons-collections
	 dev-java/commons-configuration
	 =dev-java/commons-io-1*
	 =dev-java/commons-lang-2.1*
	 dev-java/commons-logging
	 dev-java/log4j
	 dev-java/swt
	 dev-java/velocity"
        
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${RDEPEND}"

S=${WORKDIR}/${PN}

pkg_setup() {
	#FIXME: check other browser flags when new swt is in main tree
	if ! built_with_use swt seamonkey ; then
		eerror "Re-emerge swt with the 'seamonkey' USE flag"
		die
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	rm lib/*.jar
	rm dist/zekr.jar
	unzip -q dist/zekr-src.jar -d src
}

src_compile() {
	cd src
	local classpath=$(java-pkg_getjars commons-collections,commons-configuration,commons-io-1,commons-lang-2.1,commons-logging,log4j,swt-3,velocity)
	find . -name '*.java'  -print > sources.list
	ejavac -cp ${classpath} @sources.list
  	find . -name '*.class' -print > classes.list
	touch myManifest
	jar cmf myManifest zekr.jar @classes.list
}

src_install() {
	java-pkg_dojar src/zekr.jar
        doicon ${FILESDIR}/zekr.png
        java-pkg_dolauncher zekr \
        	--main net.sf.zekr.ZekrMain \
        	--pwd /usr/share/zekr \
        	-pre ${FILESDIR}/pre
        make_desktop_entry zekr "Zekr" zekr.png
        insinto /usr/share/zekr
        doins -r res
}

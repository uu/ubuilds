# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/limewire/limewire-4.12.6-r1.ebuild,v 1.5 2007/06/11 17:03:43 betelgeuse Exp $

JAVA_PKG_IUSE="source"

#IUSE="gtk"

inherit java-pkg-2 java-ant-2 subversion

MY_P="${PN}_4.13.4_dec-19-2007"

ESVN_REPO_URI="https://frostwire.svn.sourceforge.net/svnroot/frostwire/tags/${MY_P}/"

DESCRIPTION="Frostwire Java Gnutella client"
HOMEPAGE="http://www.frostwire.com"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEP="
	dev-java/commons-httpclient
	dev-java/commons-logging
	dev-java/commons-net
	dev-java/commons-pool
	dev-java/icu4j
	dev-java/jgoodies-looks
	dev-java/jmdns
	dev-java/jython
	dev-java/log4j
	dev-java/xml-commons-external"

DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

RDEPEND=">=virtual/jre-1.5
	dev-java/asm
	${COMMON_DEP}"

S="${WORKDIR}/${MY_P}"

PREFIX="/usr/share/${PN}"

src_unpack() {
#	unpack "${A}"
	subversion_src_unpack
	cd "${S}" || die "Bail out"

#Todo
#	java-ant_rewrite-classpath

	find . '(' -name '*.bat' -o -name '*.exe' ')' -delete
#	find ${S} '(' -name '*.class' -o -name '*.jar' ')' -print -delete

# Tried to remove but seem to be required :(
#	rm -fR lib/jars/osx lib/jars/windows

	cd lib/jars
	rm -fR commons-logging.jar commons-net.jar \
		log4j.jar icu4j.jar jmdns.jar

# Seems to want a modified version of commons-httpclient
#	java-pkg_jar-from commons-httpclient
	java-pkg_jar-from commons-logging

# Seems to want a modified version of commons-pool	
#	java-pkg_jar-from commons-pool
	java-pkg_jar-from commons-net
	java-pkg_jar-from log4j
	java-pkg_jar-from icu4j
	java-pkg_jar-from jmdns
	java-pkg_jar-from jgoodies-looks-1.2
	java-pkg_jar-from jython

# bye bye hashes, crude but effective :)
	cat /dev/null > "${S}/lib/jars/hashes"

}

src_compile() {
	cd "${S}/core"
	eant
	cd "${S}/gui"
	eant
	eant FrostWireJar
	
	# Make themes.jar
	cd "${S}/lib/themes"
	sh makeThemesJar.sh

	# Make message bundles
	cd "${S}/lib/native_encoded_messagebundles"
	python create_iso88591_bundles.py
	cd "${S}/lib/messagebundles"
	jar -cfv MessagesBundles.jar resources totd xml *.properties
}

src_install() {
	java-pkg_dojar "${S}/gui/lib/FrostWire.jar"
	java-pkg_dojar "${S}/lib/jars/other/themes.jar"
	java-pkg_dojar "${S}/lib/jars/id3v2.jar"
	java-pkg_dojar "${S}/lib/messagebundles/MessagesBundles.jar"

# Install resources for Frostwire. Don't let the jars deceive ya :)
# These are directly required, not sure of source atm
	insinto	${PREFIX}
	doins "${S}/gui/xml.war"
	doins "${S}/gui/update.ver"
	cd "${D}/usr/share/${PN}"
	ln -s lib/id3v2.jar
	ln -s lib/MessagesBundles.jar
	ln -s lib/themes.jar

# Bundled jars, yeah I know throw up in your mouth some
# but registering them you say, only doing so for launcher
	bjs="clink.jar daap.jar irc.jar commons-httpclient.jar commons-pool.jar \
		jcraft.jar jdic.jar jl011.jar mp3sp14.jar ProgressTabs.jar \
		tritonus.jar vorbis.jar linux/jdic_stub.jar ../i18nData/data/built/i18n.jar"
	for bj in ${bjs} ; do
		java-pkg_dojar "${S}/lib/jars/${bj}"
	done

	touch "${D}/${PREFIX}/hashes"

# Or fly like a cow with gentoo specific stuff :)
	java-pkg_dolauncher ${PN} \
		--main com.limegroup.gnutella.gui.Main \
		--java_args "-Xms64m -Xmx128m -ea -Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.NoOpLog" \
		--pwd /usr/share/${PN}

	sizes="16x16 32x32 48x48 64x64"
	for size in ${sizes} ; do
		insinto /usr/share/icons/hicolor/${size}/apps
		newins "${S}/lib/icons/hicolor/${size}/apps/${PN}.png"
	done

	make_desktop_entry frostwire FrostWire
}

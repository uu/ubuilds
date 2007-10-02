# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/limewire/limewire-4.12.6-r1.ebuild,v 1.5 2007/06/11 17:03:43 betelgeuse Exp $

JAVA_PKG_IUSE="source test"

#IUSE="gtk"
#WANT_ANT_TASKS="gettext"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Limewire Java Gnutella client"
HOMEPAGE="http://www.limewire.com"
SRC_URI="http://www.limewire.org/${PF}.zip"
LICENSE="GPL-2 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEP="
	dev-java/commons-httpclient
	dev-java/commons-logging
	dev-java/commons-net
	dev-java/commons-pool
	dev-java/guice
	dev-java/icu4j
	dev-java/jgoodies-looks
	dev-java/jmdns
	dev-java/log4j
	dev-java/xml-commons-external
	test? (
		dev-java/junit
		dev-java/xerces
		dev-util/pmd
	)"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	dev-java/aopalliance
	dev-java/commons-collections
	dev-java/jgoodies-forms
	${COMMON_DEP}"

RDEPEND=">=virtual/jre-1.5
	dev-java/asm
	${COMMON_DEP}"

S="${WORKDIR}/${PN}"

PREFIX="/usr/share/${PN}"

src_unpack() {
	unpack "${A}"
	cd "${S}"

	epatch "${FILESDIR}/build_xml.patch"

#Todo
#	java-ant_rewrite-classpath

	find . '(' -name '*.bat' -o -name '*.exe' ')' -delete

#	find ${S} '(' -name '*.class' -o -name '*.jar' ')' -print -delete
	find lib/sources tests -name "*.jar" -print -delete

# Tried to remove but seem to be required :(
#	rm -fR lib/jars/osx lib/jars/windows

	cd lib/jars
	rm -fR aopalliance.jar commons-logging.jar commons-net.jar \
		guice-1.0.jar log4j.jar forms.jar looks.jar icu4j.jar jmdns.jar

	java-pkg_jar-from --build-only aopalliance-1 aopalliance.jar

# Seems to want a modified version of commons-httpclient
#	java-pkg_jar-from commons-httpclient
	java-pkg_jar-from commons-logging

# Seems to want a modified version of commons-pool	
#	java-pkg_jar-from commons-pool
	java-pkg_jar-from commons-net
	java-pkg_jar-from guice guice.jar guice-1.0.jar
	java-pkg_jar-from log4j
	java-pkg_jar-from --build-only jgoodies-forms
	java-pkg_jar-from jgoodies-looks-1.2
	java-pkg_jar-from icu4j
	java-pkg_jar-from jmdns

	cd "${S}/components/mojito-ui/misc/lib/"
	rm -fR commons-collections-3.2.jar
	java-pkg_jar-from --build-only commons-collections

# bye bye hashes, crude but effective :)
	cat /dev/null > "${S}/lib/jars/hashes"

}

#EANT_BUILD_TARGET="compile-src"
#EANT_GENTOO_CLASSPATH=""

src_install() {
	java-pkg_newjar "${S}/${PN}-core.jar" lw-core.jar
	java-pkg_newjar "${S}/${PN}-gui.jar" lw-gui.jar
	java-pkg_dojar "${S}/components/all/dist/lw-all.jar"

# Install resources for Limewire. Don't let the jars deceive ya :)
# These are directly required, not sure of source atm
	insinto	${PREFIX}
	doins "${S}/gui/xml.war"
	doins "${S}/lib/jars/id3v2.jar"
	doins "${S}/lib/jars/other/themes.jar"
#ew, although I think this can be generated :)
	java-pkg_newjar "${S}/lib/jars/messages.jar" MessagesBundles.jar
	cd "${D}/usr/share/${PN}"
	ln -s lib/MessagesBundles.jar

# Bundled jars, yeah I know throw up in your mouth some
# but registering them you say, only doing so for launcher
	bjs="clink.jar commons-httpclient.jar commons-pool.jar daap.jar foxtrot.jar httpcore-nio.jar \
		gettext-commons.jar httpcore.jar jcraft.jar jdic.jar jl011.jar mp3sp14.jar \
		tritonus.jar vorbis.jar linux/jdic_stub.jar ../i18nData/data/built/i18n.jar"
	for bj in ${bjs} ; do
		java-pkg_dojar "${S}/lib/jars/${bj}"
	done

	touch "${D}/${PREFIX}/hashes"

# Or fly like a cow with gentoo specific stuff :)
	java-pkg_dolauncher ${PN} \
		--main com.limegroup.gnutella.gui.Main \
		--java_args "-Xms64m -Xmx128m -Djava.net.preferIPV6Addresses=false -ea -Djava.net.preferIPv4stack=true" \
		--pwd /usr/share/${PN}

	insinto /usr/share/icons/hicolor/32x32/apps
	newins "${FILESDIR}"/main-icon.png limewire.png

	make_desktop_entry limewire LimeWire
}

# In progress, fun for pain, gives me oom atm
src_test() {
	eant test-all
}

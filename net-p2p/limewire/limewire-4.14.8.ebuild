# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/limewire/limewire-4.12.6-r1.ebuild,v 1.5 2007/06/11 17:03:43 betelgeuse Exp $

JAVA_PKG_IUSE="source test"

#IUSE="gtk"
#WANT_ANT_TASKS="ant-"

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
	dev-java/guice
	dev-java/icu4j
	dev-java/jgoodies-looks
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
	dev-java/commons-pool
	dev-java/jgoodies-forms
	dev-java/jmdns
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
	find -path lib/sources -or -path tests -name "*.jar" -print -delete

# Tried to remove but seem to be required :(
#	rm -fR lib/jars/osx lib/jars/windows

	cd lib/jars
	rm -fR aopalliance.jar commons-logging.jar commons-net.jar guice-1.0.jar log4j.jar forms.jar looks.jar icu4j.jar jmdns.jar
	java-pkg_jar-from --build-only aopalliance-1 aopalliance.jar
#
# Seems to want a modified version of commons-httpclient
#	java-pkg_jar-from commons-httpclient
	java-pkg_jar-from commons-logging
#
# Seems to want a modified version of commons-pool	
#	java-pkg_jar-from commons-pool
	java-pkg_jar-from commons-net
	java-pkg_jar-from guice guice.jar guice-1.0.jar
	java-pkg_jar-from log4j
	java-pkg_jar-from jgoodies-forms
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
	java-pkg_dojar "${S}/lw-core.jar"
	java-pkg_dojar "${S}/lw-gui.jar"
	java-pkg_dojar "${S}/components/all/dist/lw-all.jar"

# Install resources for Limewire. Don't let the jars deceive ya :)
# These are directly required, not sure of source atm
	insinto	${PREFIX}
	doins "${S}/gui/xml.war"
	doins "${S}/lib/jars/id3v2.jar"
	doins "${S}/lib/jars/messages.jar"
	doins "${S}/lib/jars/other/themes.jar"

# Bundled jars, yeah I know throw up in your mouth some
	doins "${S}/lib/jars/clink.jar"
	doins "${S}/lib/jars/daap.jar
	doins "${S}/lib/jars/foxtrot.jar
	doins "${S}/lib/jars/httpcore-nio.jar"
	doins "${S}/lib/jars/httpcore.jar"
	doins "${S}/lib/jars/jcraft.jar"
	doins "${S}/lib/jars/jdic.jar"
	doins "${S}/lib/jars/jl011.jar"
	doins "${S}/lib/jars/mp3sp14.jar"
	doins "${S}/lib/jars/tritonus.jar"
	doins "${S}/lib/jars/vorbis.jar"
	doins "${S}/lib/jars/linux/jdic_stub.jar"

	touch "${D}/${PREFIX}/hashes"

# Custom launcher
	exeinto /usr/bin
	newexe ${FILESDIR}/limewire.sh limewire

# Install default bash script, which requires hacking and gentoo integration
#	cd "${S}/gui/"
#	exeinto /usr/bin
#	newexe run limewire

# Or fly like a cow with gentoo specific stuff :)
#	java-pkg_dolauncher limewire --main com.limegroup.gnutella.gui.Main

#	newenvd limewire.envd 99limewire

	insinto /usr/share/icons/hicolor/32x32/apps
	newins "${FILESDIR}"/main-icon.png limewire.png

	make_desktop_entry limewire LimeWire
}

# In progress, fun for pain, gives me oom atm
src_test() {
	eant test-all
}

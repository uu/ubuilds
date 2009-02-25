# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/frostwire/frostwire-4.13.5-r1.ebuild,v 1.3 2009/08/05 18:11:23 wltjr Exp $

#svn export https://frostwire.svn.sourceforge.net/svnroot/frostwire/tags/frostwire_4.17.1_nov_7_2009 frostwire-4.17.1
#tar -cjf frostwire-4.17.1.tar.bz2 frostwire-4.17.1/

EAPI=1
JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Frostwire Java Gnutella client"
HOMEPAGE="http://www.frostwire.com"
SRC_URI="http://www.frostwire.com/frostwire/${PV}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="gtk"
IUSE=""

#	dev-java/commons-httpclient
#	dev-java/commons-pool

#dev-java/jaudiotagger:0

COMMON_DEP="
	dev-java/aopalliance:1
	dev-java/commons-codec:0
	dev-java/jgoodies-forms:0
	dev-java/commons-logging
	dev-java/commons-net
	dev-java/icu4j:0
	dev-java/jgoodies-looks:1.2
	dev-java/jmdns
	dev-java/jython
	dev-java/log4j
	dev-java/xml-commons-external"

DEPEND="|| ( =virtual/jdk-1.6* =virtual/jdk-1.5* )
	${COMMON_DEP}"

RDEPEND="|| ( =virtual/jre-1.6 =virtual/jre-1.5* )
	dev-java/asm
	${COMMON_DEP}"

PREFIX="/usr/share/${PN}"

#remove before adding to tree
RESTRICT="fetch"

src_unpack() {
	unpack ${A}
	cd "${S}"

	#sed -i -e 's_/tmp_'
#Todo
#	java-ant_rewrite-classpath

	find . '(' -name '*.bat' -o -name '*.exe' ')' -delete
#	find ${S} '(' -name '*.class' -o -name '*.jar' ')' -print -delete

# Tried to remove but seem to be required :(
#	rm -fR lib/jars/osx lib/jars/windows

#TODO jars
# clink.jar
# daap.jar http://getittogether.sourceforge.net/
# foxtrot.jar
# gettext-commons.jar http://xnap-commons.sourceforge.net/gettext-commons/
# guice.jar
# httpclient-4.0-alpha3.jar
# httpcore-4.0-beta2.jar
# httpcore-nio-4.0-alpha7.jar
# httpcore-niossl-4.0-alpha7.jar

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

	java-pkg_jar-from aopalliance-1
	java-pkg_jar-from commons-codec
	java-pkg_jar-from jgoodies-forms

	#org.jaudiotagger.tag.TagFieldKey.Copyright missing
	#java-pkg_jar-from jaudiotagger

# bye bye hashes, crude but effective :)
	cat /dev/null > "${S}/lib/jars/hashes"
}

src_compile() {
	rm lib/jars/messages.jar || die
	LANG="en" LC_ALL="en_NZ.utf8" eant lw-gettext-extract lw-bundle-messages
	pushd "components" > /dev/null
		eant jar
	popd > /dev/null
	cd "${S}/core"
	eant
	cd "${S}/gui"
	eant

	cd "${S}"
	eant jar
	#eant FrostWireJar

	# Make themes.jar
	cd "${S}/lib/themes"
	sh makeThemesJar.sh

	# temp fix/hack for bug #215423 till bug #180755 is resolved
	# bit noisy when not found, but better than command not found :)
	#[ ! -p native2ascii > /dev/null ] && export PATH="${PATH}:$(java-config -O)/bin"
}

src_install() {
	java-pkg_dojar "${S}/dist/FrostWire.jar"
	java-pkg_dojar "${S}/lib/jars/other/themes.jar"
	java-pkg_dojar "${S}/lib/jars/messages.jar"

# Install resources for Frostwire. Don't let the jars deceive ya :)
# These are directly required, not sure of source atm
	insinto	${PREFIX}
	cd "${D}/usr/share/${PN}"
	ln -s lib/messages.jar
	ln -s lib/themes.jar

# Bundled jars, yeah I know throw up in your mouth some
# but registering them you say, only doing so for launcher
	bjs="clink.jar daap.jar commons-codec-1.3.jar \
		foxtrot.jar gettext-commons.jar guice-1.0.jar \
		httpclient-4.0-alpha3.jar httpcore-4.0-beta2.jar \
		httpcore-nio-4.0-beta2.jar httpcore-niossl-4.0-alpha7.jar \
		jaudiotagger.jar jcraft.jar jdic.jar jflac.jar jl.jar jogg.jar \
		jorbis.jar mp3spi.jar onion-common.jar onion-fec.jar \
		ProgressTabs.jar tritonus.jar vorbisspi.jar linux/jdic_stub.jar"
	for bj in ${bjs} ; do
		java-pkg_dojar "${S}/lib/jars/${bj}"
	done
	java-pkg-dojar "${S}/lib/i18nData/data/built/i18n.jar"
	java-pkg_dojar "${S}/components/all/dist/lw-all.jar"

	touch "${D}/${PREFIX}/hashes"

	java-pkg_dolauncher ${PN} \
		--main com.limegroup.gnutella.gui.Main \
		--java_args "-Xms64m -Xmx128m -ea -Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.NoOpLog" \
		--pwd /usr/share/${PN}

	sizes="32x32 48x48 64x64"
	for size in ${sizes} ; do
		insinto /usr/share/icons/hicolor/${size}/apps
		doins "${S}/lib/icons/hicolor/${size}/apps/${PN}.png"
	done

	make_desktop_entry frostwire FrostWire
}

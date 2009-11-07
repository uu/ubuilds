# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="source"
WANT_CLOJURE_CONTRIB="true"
CLOJURE_CONTRIB_VERSION="1.0.0.20091102"

inherit clojure java-ant-2

# source id for this version
SRC_ID="11066"

DESCRIPTION="Provides the server for VimClojure's interactive features."
HOMEPAGE="http://kotka.de/projects/clojure/vimclojure.html"
SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=${SRC_ID} -> vimclojure-${PV}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

COMMON_DEP="dev-java/nailgun:0"
RDEPEND="${COMMON_DEP}"
DEPEND="${COMMON_DEP}
	app-arch/unzip
	userland_GNU? ( sys-apps/findutils )"

S="${WORKDIR}/vimclojure-${PV}"

JAVA_ANT_REWRITE_CLASSPATH=1
EANT_BUILD_TARGET="artifacts"
EANT_GENTOO_CLASSPATH="nailgun"

java_prepare() {
	find . -iname '*.jar' -exec rm -v {} + || die "Unable to remove packed JAR files"

	# delete packed nailgun sources
	rm -r src/com/martiansoftware src/org/apache \
		|| die "Unable to remove bundled nailgun sources"
}

src_install() {
	java-pkg_dolauncher "${PN}-server" \
		--main com.martiansoftware.nailgun.NGServer \
		--java_args "-server" \
		--pkg_args '${GORILLA_HOST}:${GORILLA_PORT}'
	java-pkg_newjar build/vimclojure.jar
	use source && clojure_dosrc src

	newenvd "${FILESDIR}/gorilla.env" 99gorilla \
		|| die "Failed to install environment file."
	newconfd "${FILESDIR}/gorilla.conf" gorilla \
		|| die "Failed to install gorilla init configuration file"
	newinitd "${FILESDIR}/gorilla.init" gorilla \
		|| die "Failed to install gorilla init script"
	dobin "${FILESDIR}/gorilla-client" \
		|| die "Unable to install gorilla-client script"
}

pkg_postinst() {
	elog "The gorilla server may be run using Gentoo's init scripts.  If you do so, note"
	elog "that gorilla does not implement any kind of security precautions and should be"
	elog "run by a non-privileged user.  You may run the server yourself using"
	elog "gorilla-server.  The environment variables GORILLA_HOST and GORILLA_PORT"
	elog "determine where gorilla will be listening."
}

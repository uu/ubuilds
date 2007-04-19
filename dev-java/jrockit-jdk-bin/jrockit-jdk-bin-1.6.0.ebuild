# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

# WARNING: This is the default VM on ia64, so treat this ebuild
# with proper care.

# The stripping of symbols seems to mess up the BEA code. Not sure why.
RESTRICT="nostrip fetch"

inherit java-vm-2 versionator

PV_MAJOR="$(get_version_component_range 1-3 ${PV})"
UPSTREAM_RELEASE="27.2.0"

SRC_URI_BASE="jrockit-R${UPSTREAM_RELEASE}-jdk${PV_MAJOR}-linux-"
SRC_URI="x86? ( ${SRC_URI_BASE}ia32.bin )
		amd64? ( ${SRC_URI_BASE}x64.bin )"
DESCRIPTION="BEA WebLogic's J2SE Development Kit, R${UPSTREAM_RELEASE}"

HOMEPAGE="http://commerce.bea.com/products/weblogicjrockit/jrockit_prod_fam.jsp"

LICENSE="jrockit"
SLOT="1.6"
KEYWORDS="-* amd64 x86"
IUSE=""

DEPEND=">=app-arch/unzip-5.50-r1"
JAVA_PROVIDE="jdbc-stdext jdbc-rowset"

QA_TEXTRELS_amd64="opt/${P}/mercuryprofiler/lib/sparc-sunos/libprobejni.so
	opt/${P}/mercuryprofiler/lib/x86-linux/libprobejni.so"

# not working for some reason...
QA_EXECSTACK_amd64="opt/${P}/mercuryprofiler/bin/sparc-sunos/systemmetrics
	opt/${P}/mercuryprofiler/lib/sparc-sunos/libprobejni.so"

pkg_nofetch() {
	einfo "Please download ${A} from:"
	einfo ${HOMEPAGE}
	einfo "and move it to ${DISTDIR}"
}

src_unpack() {
	mkdir "${S}"
	cd "${S}"
	#unpack cannot determine file format
	unzip ${DISTDIR}/${A}

	#this is ugly but don't see any better way
	unzip *sdk_no_jre.zip
	rm *sdk_no_jre.zip
	mkdir jre
	unzip *jre.zip -d jre
	rm *jre.zip
}

src_install() {
	local dirs="bin db demo include jre lib mercuryprofiler sample src.zip"

	insinto "/opt/${P}"
	for i in ${dirs} ; do
		doins -r $i || die
	done

	newdoc README.txt README
	dodoc LICENSE

	chmod +x ${D}/opt/${P}/bin/* ${D}/opt/${P}/jre/bin/* || die "Could not chmod"
	set_java_env
}

pkg_postinst () {
	# Set as default VM if none exists
	java-vm-2_pkg_postinst
	elog "Please review the license agreement in /usr/share/doc/${PF}/LICENSE"
	elog "If you do not agree to the terms of this license, please uninstall this package"
}

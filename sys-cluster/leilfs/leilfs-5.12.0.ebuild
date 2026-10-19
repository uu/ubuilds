# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

EAPI=8

inherit autotools cmake

DESCRIPTION="LeilFS is a free-and open source, distributed POSIX file system."
HOMEPAGE="https://leilfs.com"
MY_PV="${PV/_/-}"
S=${WORKDIR}/leilfs-${MY_PV}
SRC_URI="https://github.com/leil-io/leilfs/archive/refs/tags/v${MY_PV}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="cgi"
RDEPEND="
	acct-user/leilfs
	acct-group/leilfs
	!sys-cluster/moosefs
	!sys-cluster/lizardfs
	!sys-cluster/saunafs
	dev-libs/judy
	dev-libs/spdlog
	app-text/asciidoc
	dev-ruby/asciidoctor
	cgi? ( dev-python/chardet )
	dev-libs/jemalloc
	dev-libs/thrift
	dev-cpp/prometheus-cpp
	dev-cpp/yaml-cpp
	>=sys-fs/fuse-3.16
	dev-libs/isa-l
	>=sys-devel/gcc-14.0.0"
DEPEND="${RDEPEND}"


src_configure() {
	cd $BUILD_DIR
	# Ugly. gentoo's cmake_src_configure breaks linkage
	local mycmakeargs="
		-DENABLE_TESTS=NO
		-DENABLE_WERROR=YES
		-DENABLE_CCACHE=NO
		-DENABLE_DOCS=YES
		-DENABLE_JEMALLOC=NO
		-DENABLE_INODE64=NO
		-DENABLE_POLONAISE=NO
		-DENABLE_UTILS=YES
		-DTHROW_INSTEAD_OF_ABORT=YES
		-DCMAKE_INSTALL_PREFIX=/
		-Wno-dev
	"
	cmake -G Ninja ../${P} $mycmakeargs
}

src_compile() {
	cd $BUILD_DIR
	cmake_src_compile
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}/leilfs.initd" leilfs
	newconfd "${FILESDIR}/leilfs.confd" leilfs
	if use cgi; then
		newinitd "${FILESDIR}/leilfscgiserver.initd" leilfscgiserver
		newconfd "${FILESDIR}/leilfscgiserver.confd" leilfscgiserver
	fi

	diropts -m0750 -o leilfs -g leilfs
	dodir "/var/lib/leilfs" "/etc/leilfs"
	keepdir "/var/lib/leilfs" "/etc/leilfs"
	chown -R leilfs:leilfs "${D}/var/lib/leilfs" || die
	chmod 750 "${D}/var/lib/leilfs" || die
}

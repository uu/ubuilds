# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

EAPI=8

inherit autotools cmake

DESCRIPTION="SaunaFS is a free-and open source, distributed POSIX file system."
HOMEPAGE="https://saunafs.com"
SRC_URI="https://github.com/leil-io/saunafs/archive/refs/tags/v${PV}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="cgi +fuse -devel"
RDEPEND="
	acct-user/odyssey
	acct-group/odyssey
	!sys-cluster/moosefs
	dev-libs/judy
	dev-libs/spdlog
	app-text/asciidoc
	dev-libs/jemalloc
	dev-libs/thrift
	dev-cpp/prometheus-cpp
	fuse? ( >=sys-fs/fuse-3.16 )
	dev-libs/isa-l
	>=sys-devel/gcc-14.0.0"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DENABLE_TESTS=NO
		-DENABLE_WERROR=ON
		-DENABLE_CCACHE=OFF
		-DENABLE_DOCS=YES
		-DENABLE_JEMALLOC=YES
		-DENABLE_POLONAISE=OFF
		-DENABLE_UTILS=ON
		-DTHROW_INSTEAD_OF_ABORT=YES
		-DCMAKE_INSTALL_PREFIX=/
		-Wno-dev
	)

if use devel; then
  mycmakeargs+=( -DENABLE_CLIENT_LIB=YES )
fi
cmake_src_configure
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}/saunafs.initd" saunafs
	newconfd "${FILESDIR}/saunafs.confd" saunafs
	if use cgi; then
		newinitd "${FILESDIR}/saunafscgiserver.initd" saunafscgiserver
		newconfd "${FILESDIR}/saunafscgiserver.confd" saunafscgiserver
	fi

	diropts -m0750 -o saunafs -g saunafs
	dolib.so "${BUILD_DIR}"/src/slogger/libslogger.so
	dolib.so "${BUILD_DIR}"/src/errors/libsfserr.so
	dolib.so "${BUILD_DIR}"/src/common/libsfscommon.so
	dolib.so "${BUILD_DIR}"/src/metarestore/libmetarestore.so
	dolib.so "${BUILD_DIR}"/src/admin/libsaunafs-admin-lib.so
	#dolib.so "${BUILD_DIR}"/src/mount/libmount.so
	dolib.so "${BUILD_DIR}"/external/libcrcutil.so
	dolib.so "${BUILD_DIR}"/src/chunkserver/libchunkserver.so
	dolib.so "${BUILD_DIR}"/src/protocol/libsafsprotocol.so
	dolib.so "${BUILD_DIR}"/src/chunkserver/chunkserver-common/libchunkserver-common.so
	dolib.so "${BUILD_DIR}"/src/metrics/libmetrics.so
	dolib.so "${BUILD_DIR}"/src/master/libmaster.so
	dolib.so "${BUILD_DIR}"/src/metalogger/libmetalogger.so
	dodir "/var/lib/saunafs"
	keepdir "/var/lib/saunafs"
	chown -R saunafs:saunafs "${D}/var/lib/saunafs" || die
	chmod 750 "${D}/var/lib/saunafs" || die
}


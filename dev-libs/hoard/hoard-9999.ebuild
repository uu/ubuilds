# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit flag-o-matic git-r3

DESCRIPTION="HOARD Memory Allocator"
HOMEPAGE="http://www.hoard.org"
EGIT_REPO_URI="https://github.com/emeryberger/Hoard.git"
EGIT_OPTIONS="--recursive"
EGIT_HAS_SUBMODULES=true
SRC_URI=""
#SRC_URI="http://www.cs.umass.edu/~emery/hoard/${P}/lib${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~x86-fbsd"
IUSE="doc debug"

DEPEND="sys-devel/llvm[clang]
	sys-devel/clang
"
RDEPEND=""

#S="${WORKDIR}/emeryberger-Hoard-d065953"

src_compile() {
	# Makefile forces hardcode -march cflags (pentium4 and nocona), so we
	# need to substitue these values with the one supplied by the user into
	# the make.conf.
	# NOTE: this is necessary to avoid binary breakage and to fix runtime text
	# relocations too
	sed -i \
		-e "s:-march=pentium4:-march=$(get-flag march) -fPIC:" \
		-e "s:-march=nocona:-march=$(get-flag march) -fPIC:" \
		src/Makefile || die "seding src/Makefile failed."

	local target
	case ${ARCH} in
	x86)
		target="Linux-gcc-x86"
		;;
	amd64)
		target="Linux-gcc-x86_64"
		;;
	x86-fbsd)
		target="Linux-gcc-x86"
		;;
	*)
		target="generic-gcc"
		;;
	esac

	use debug && target="${target}-debug"
	cd src/
	emake ${target} || die "emake failed."
}

src_install() {
	# installing env.d
	cat <<EOF > "${T}"/01hoard
LD_PRELOAD=/usr/$(get_libdir)/libhoard.so
EOF
	doenvd "${T}"/01hoard

	# installing libhoard
	dolib.so src/libhoard.so
	doheader -r src/include/hoard/
	# installing docs
	dodoc {AUTHORS,COPYING,NEWS,README.md,THANKS}
	if use doc; then
		dohtml -r doc/*
	fi
}

# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GIT_COMMIT="7f00c780" # Change this when you update the ebuild
EGO_PN="gitlab.com/gitlab-org/${PN}"
EGO_VENDOR=( "github.com/mitchellh/gox 9cc4875981" )

inherit golang-vcs-snapshot-r1 linux-info systemd user

DESCRIPTION="The official GitLab Runner, written in Go"
HOMEPAGE="https://gitlab.com/gitlab-org/gitlab-runner"
ARCHIVE_URI="https://${EGO_PN}/repository/v${PV}/archive.tar.gz -> ${P}.tar.gz"
SRC_URI="${ARCHIVE_URI} ${EGO_VENDOR_URI}"
RESTRICT="mirror test"
# test requires tons of stuff, doesn't work with portage

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+build-images debug pie"

RDEPEND="
	app-arch/xz-utils
	app-emulation/docker
"
DEPEND="${RDEPEND}
	build-images? ( app-emulation/qemu )
"

DOCS=( CHANGELOG.md README.md )
QA_PRESTRIPPED="usr/libexec/.*"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

CONFIG_CHECK="~BINFMT_MISC"
ERROR_BINFMT_MISC="CONFIG_BINFMT_MISC: is required to build ARM images"

pkg_pretend() {
	if use build-images && [[ "${MERGE_TYPE}" != binary ]]; then
		# shellcheck disable=SC2086
		if has network-sandbox ${FEATURES}; then
			ewarn
			ewarn "${CATEGORY}/${PN} requires internet access during"
			ewarn "compile phase, you must disable 'network-sandbox'"
			ewarn "in FEATURES (${EROOT}/etc/portage/make.conf)."
			ewarn
			die "[network-sandbox] is enabled in FEATURES"
		fi

		# Does portage have access to docker's socket?
		if getent group docker | grep &>/dev/null "\\bportage\\b"; then
			# Is docker running?
			if ! docker info &>/dev/null; then
				ewarn
				ewarn "Although portage is a member of the 'docker' group,"
				ewarn "docker must be running on your system during build time."
				ewarn
				die "docker doesn't seems to be properly running"
			fi
		else
			ewarn
			ewarn "In order for portage be able to build the docker images, you must"
			ewarn "add portage to the 'docker' group (e.g. usermod -aG docker portage)."
			ewarn "Also, docker must be running on your system during build time."
			ewarn
			die "portage doesn't seems to be a member of the 'docker' group"
		fi

		# Is 'arm' and 'armeb' registered?
		if [[ ! -e "/proc/sys/fs/binfmt_misc/arm" ]] && \
			[[ ! -e "/proc/sys/fs/binfmt_misc/armeb" ]]; then
			ewarn
			ewarn "You must enable support for ARM binaries through Qemu."
			ewarn
			ewarn "Please execute (as root) the script described here:"
			ewarn "https://${EGO_PN}/blob/v${PV}/docs/development/README.md#2-install-docker-engine"
			ewarn
			ewarn "Note: You probably don't need to modprobe or mount binfmt_misc,"
			ewarn "so comment out those parts in the aforementioned script."
			ewarn
			die "arm and armeb doesn't seems to be registered"
		fi
	fi
}

pkg_setup() {
	(use build-images && [[ "${MERGE_TYPE}" != binary ]]) && \
		linux-info_pkg_setup
}

src_prepare() {
	mkdir -p out/helper-images || die
	default
}

src_compile() {
	export GOPATH="${G}"
	local PATH="${G}/bin:$PATH" BUILT
	BUILT="$(date -u '+%Y-%m-%dT%H:%M:%S%:z')"
	local myldflags=(
		"$(usex !debug '-s -w' '')"
		-X "${EGO_PN}/common.NAME=${PN}"
		-X "${EGO_PN}/common.VERSION=${PV}"
		-X "${EGO_PN}/common.REVISION=${GIT_COMMIT}"
		-X "${EGO_PN}/common.BUILT=${BUILT}"
		-X "${EGO_PN}/common.BRANCH=non-git"
	)
	local mygoargs=(
		-v -work -x
		"-buildmode=$(usex pie pie exe)"
		"-asmflags=all=-trimpath=${S}"
		"-gcflags=all=-trimpath=${S}"
		-ldflags "${myldflags[*]}"
	)

	if use build-images; then
		local i img_arch=( x86_64 arm )
		local osarch osarch_x86_64="amd64" osarch_arm="arm"

		# Build gox locally
		go install ./vendor/github.com/mitchellh/gox || die

		for i in "${img_arch[@]}"; do
			osarch="osarch_${i}"
			ebegin "Building gitlab-runner-prebuilt-${i}-${GIT_COMMIT}"
			# Building gitlab-runner-helper.${i}
			gox -osarch=linux/"${!osarch}" \
				-ldflags "${myldflags[*]}" \
				-output="dockerfiles/build/binaries/gitlab-runner-helper.${i}" \
				./apps/gitlab-runner-helper || die

			# Build docker images
			docker build -t "gitlab/gitlab-runner-helper:${i}-${GIT_COMMIT}" \
				-f "dockerfiles/build/Dockerfile.${i}" dockerfiles/build || die
			docker create --name="gitlab-runner-prebuilt-${i}-${GIT_COMMIT}" \
				"gitlab/gitlab-runner-helper:${i}-${GIT_COMMIT}" /bin/sh || die
			docker export -o "out/helper-images/prebuilt-${i}.tar" \
				"gitlab-runner-prebuilt-${i}-${GIT_COMMIT}" || die
			docker rm -f "gitlab-runner-prebuilt-${i}-${GIT_COMMIT}" || die
			xz -f -9 "out/helper-images/prebuilt-${i}.tar" || die
			eend $?
		done
	fi

	go build "${mygoargs[@]}" || die
}

src_install() {
	exeinto /usr/libexec/gitlab-runner
	doexe gitlab-runner
	dosym ../libexec/gitlab-runner/gitlab-runner /usr/bin/gitlab-runner
	use debug && dostrip -x /usr/libexec/gitlab-runner/gitlab-runner

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	if use build-images; then
		insinto /usr/libexec/gitlab-runner/helper-images
		doins -r out/helper-images/*.tar.xz
	fi

	diropts -m 0700
	dodir /etc/gitlab-runner
	keepdir /var/log/gitlab-runner

	insinto /etc/gitlab-runner
	doins config.toml.example

	einstalldocs
}

pkg_preinst() {
	enewgroup gitlab-runner
	enewuser gitlab-runner -1 /bin/bash /var/lib/gitlab-runner gitlab-runner
}

pkg_postinst() {
	if use build-images && [[ "${MERGE_TYPE}" != binary ]]; then
		ewarn
		ewarn "As a security measure, you should remove portage from"
		ewarn "the 'docker' group (e.g. gpasswd -d portage docker)."
		ewarn
	fi
}

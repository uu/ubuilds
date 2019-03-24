# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GIT_COMMIT="8bb608ff" # Change this when you update the ebuild
EGO_PN="gitlab.com/gitlab-org/${PN}"
EGO_VENDOR=( "github.com/mitchellh/gox 9cc4875981" )

inherit golang-vcs-snapshot-r1 systemd user

DESCRIPTION="The official GitLab Runner, written in Go"
HOMEPAGE="https://gitlab.com/gitlab-org/gitlab-runner"
ARCHIVE_URI="https://${EGO_PN}/repository/v${PV}/archive.tar.gz -> ${P}.tar.gz"
SRC_URI="${ARCHIVE_URI} ${EGO_VENDOR_URI}"
RESTRICT="mirror test"
# test requires tons of stuff, doesn't work with portage

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+build-images debug pie static"

RDEPEND="build-images? ( app-emulation/docker )"
DEPEND="${RDEPEND}"

DOCS=( CHANGELOG.md README.md )
QA_PRESTRIPPED="usr/libexec/.*"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
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

		mkdir -p out/helper-images || die
	fi
}

src_compile() {
	export GOPATH="${G}"
	export CGO_CFLAGS="${CFLAGS}"
	export CGO_LDFLAGS="${LDFLAGS}"
	(use static && ! use pie) && export CGO_ENABLED=0
	(use static && use pie) && CGO_LDFLAGS+=" -static"

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
		-buildmode "$(usex pie pie exe)"
		-asmflags "all=-trimpath=${S}"
		-gcflags "all=-trimpath=${S}"
		-ldflags "${myldflags[*]}"
		-tags "$(usex static 'netgo' '')"
		-installsuffix "$(usex static 'netgo' '')"
	)

	if use build-images; then
		# Build gox locally
		go install ./vendor/github.com/mitchellh/gox || die

		ebegin "Building gitlab-runner-prebuilt-x86_64-${GIT_COMMIT}"
		gox -osarch=linux/amd64 \
			-ldflags "${myldflags[*]}" \
			-output="dockerfiles/build/binaries/gitlab-runner-helper.x86_64" \
			./apps/gitlab-runner-helper || die

		docker build -t "gitlab/gitlab-runner-helper:x86_64-${GIT_COMMIT}" \
			-f "dockerfiles/build/Dockerfile.x86_64" dockerfiles/build || die
		docker create --name="gitlab-runner-prebuilt-x86_64-${GIT_COMMIT}" \
			"gitlab/gitlab-runner-helper:x86_64-${GIT_COMMIT}" /bin/sh || die
		docker export -o "out/helper-images/prebuilt-x86_64.tar" \
			"gitlab-runner-prebuilt-x86_64-${GIT_COMMIT}" || die
		docker rm -f "gitlab-runner-prebuilt-x86_64-${GIT_COMMIT}" || die
		xz -f -9 "out/helper-images/prebuilt-x86_64.tar" || die
		eend $?
	fi

	go build "${mygoargs[@]}" || die
}

src_install() {
	exeinto /usr/libexec/gitlab-runner
	doexe gitlab-runner
	dosym ../libexec/gitlab-runner/gitlab-runner /usr/bin/gitlab-runner
	use debug && dostrip -x /usr/libexec/gitlab-runner/gitlab-runner
	einstalldocs

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

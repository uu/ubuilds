# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: composer.eclass
# @MAINTAINER:
# Jan Chren (rindeal) <dev.rindeal+gentoo@gmail.com>
# @BLURB: Support eclass for PHP packages using composer

if [ -z "${_COMPOSER_ECLASS}" ] ; then

case "${EAPI:-0}" in
	6) ;;
	*) die "Unsupported EAPI='${EAPI}' for '${ECLASS}'" ;;
esac

DEPEND="app-misc/jq"

_composer_do_env_dir() {
	local var="${1}" default="${2}"

	[ -z "${!var}" ] && declare -g "${var}"="${default}"
	export "${var}"
	mkdir -p "${!var}" || die

	debug-print "${var}='${!var}'"
}

## If set to 1, this env var will make Composer behave as if you passed
## the `--no-interaction` flag to every command. This can be set on build boxes/CI.
export COMPOSER_NO_INTERACTION=1

composer_pkg_setup() {
	: ${COMPOSER_INSTALL_DIR:="/usr/share/${PF}"}

	_composer_do_env_dir \
		COMPOSER_HOME "${HOME}"

	_composer_do_env_dir \
		COMPOSER_CACHE_DIR "${S}/composer"

	## By setting this var you can make Composer install the dependencies into a directory
	## other than `vendor`.
	_composer_do_env_dir \
		COMPOSER_VENDOR_DIR "${S}/vendor"

	## By setting this option you can change the `bin` (Vendor Binaries) directory
	## to something other than `vendor/bin`.
	_composer_do_env_dir \
		COMPOSER_BIN_DIR "${T}/composer/bin"

	# this dir shouldn't exist for now
	# rm -rf "${S}" # || die
}

ecomposer() {
	local composer=(
		composer

		--no-interaction
		#-vvv # max verbosity
	)

	elog "Running: '${composer[*]} ${*}'"
	elog "ENV: $(env)"
	"${composer[@]}" "${@}" || die "Composer failed to run"
}

ecomposer_install() {
	local options=(
		--optimize-autoloader
		--no-dev
		--prefer-dist
	)

	ecomposer "${options[@]}" install "${@}"
}

composer_list_bin() {
	local code composer_json="composer.json"

	## first check if any bins exist
	jq -e -r '.bin' "${composer_json}" >/dev/null
	code=$?
	[ ${code} -eq 1 ] && return 0
	[ ${code} -gt 1 ] && die "jq failed to run with exit code '${code}'"

	jq -r '.bin[]' "${composer_json}" || die
}

composer_copy_install_all() {
	mkdir -p "${ED}${COMPOSER_INSTALL_DIR}" || die
	cp -r "${S}"/* "${ED}${COMPOSER_INSTALL_DIR}" || die
}

composer_install_bins() {
	local bin_list="${T}/composer-bins"
	composer_list_bin > "${bin_list}"

	while read b ; do
		fperms a+x "${COMPOSER_INSTALL_DIR}/${b}"
		dosym "${COMPOSER_INSTALL_DIR}/${b}" "/usr/bin/${b##*/}"
	done < "${bin_list}"
}

_COMPOSER_ECLASS=1
fi

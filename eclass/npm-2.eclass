case ${EAPI} in
    2|3|4|5) : ;;
    *)     die "npm.eclass: unsupported EAPI=${EAPI:-0}" ;;
esac

inherit multilib

if [[ -z $NPM_MODULE ]]; then
	NPM_MODULE="${PN}"
fi

NPM_FILES="index.js lib package.json ${NPM_MODULE}.js"

HOMEPAGE="https://www.npmjs.org/package/${PN}"
SRC_URI="http://registry.npmjs.org/${PN}/-/${P}.tgz"


npm-2_src_compile() {
    true
}


[ -z "$SRC_URI" ] && SRC_URI="http://registry.npmjs.org/${PN}/-/${P}.tgz"

DEPEND="${DEPEND} net-libs/nodejs"

npm-2_src_unpack() {
    unpack "${A}"
    mv "${WORKDIR}/package" ${S}
}

npm-2_src_configure() {
	npm config set datadir "${ED}/usr/share"
	npm config set indodir "${ED}/usr/share/info"
	npm config set localstatedir "${ED}/var/lib"
	npm config set prefix "${ED}/usr"
	npm config set mandir "${ED}/usr/share/man"
	npm config set sysconfdir "${ED}/etc"
	#npm config list
}

npm-2_src_install() {
	npm install -g "${DISTDIR}/${A}" || die
}
EXPORT_FUNCTIONS src_configure src_install src_unpack src_compile

EAPI=5

inherit npm-2

DESCRIPTION="An elegant web interface for Unitech/PM2."

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-nodejs/pm2"
RDEPEND=">=net-libs/nodejs-0.10.36
	${DEPEND}"


src_install() {
	npm-2_src_install
	newinitd ${FILESDIR}/${PN}.init ${PN}
	newconfd ${FILESDIR}/${PN}.conf ${PN}
}

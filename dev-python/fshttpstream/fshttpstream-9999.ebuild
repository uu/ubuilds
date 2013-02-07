# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/paramiko/paramiko-1.7.7.2.ebuild,v 1.1 2012/08/17 07:04:47 patrick Exp $

EAPI="4"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils git-2

DESCRIPTION="Websocket proxy server to send freeswitch events to websocket client."
HOMEPAGE="https://github.com/tamiel/fshttpstream"
#SRC_URI="http://www.lag.net/paramiko/download/${P}.tar.gz"
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
EGIT_REPO_URI="git://github.com/tamiel/fshttpstream.git"
EGIT_BRANCH="0.3"

LICENSE="MPL 1.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND="dev-python/gevent-websocket
		 dev-python/telephonie"
DEPEND="${RDEPEND}
	dev-python/setuptools"
#S=${S}/src/

src_compile() {
  S=${S}/src/
}

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test.py --verbose
	}
	python_execute_function testing
}

src_install() {
	#cd ${S}/src
	distutils_src_install

}

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/paramiko/paramiko-1.7.7.2.ebuild,v 1.1 2012/08/17 07:04:47 patrick Exp $

EAPI="5"
PYTHON_COMPAT=(python2_7)

inherit distutils-r1

DESCRIPTION="Framework to create telephony applications using FreeSWITCH"
HOMEPAGE="https://pypi.python.org/pypi/telephonie"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MPL 1.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="doc examples"

RDEPEND="dev-python/gevent-websocket"
DEPEND="${RDEPEND}
	dev-python/setuptools"

#src_test() {
#	testing() {
#		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test.py --verbose
#	}
#	python_execute_function testing
#}

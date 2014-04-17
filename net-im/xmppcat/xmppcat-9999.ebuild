# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/sendxmpp/sendxmpp-1.23.ebuild,v 1.6 2013/09/14 10:02:13 ago Exp $

EAPI=5

inherit python eutils git-2

DESCRIPTION="xmppcat is a python-script to send xmpp (jabber), similar to what mail(1) does for mail."
HOMEPAGE="https://github.com/mtorromeo/xmppcat"
EGIT_REPO_URI="https://github.com/mtorromeo/xmppcat"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 hppa ppc sparc x86"
IUSE=""

DEPEND="dev-python/setuptools dev-python/configparser dev-python/dnspython dev-python/pyasn1-modules"


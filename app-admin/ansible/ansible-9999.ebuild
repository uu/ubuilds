# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: /repos/ubuilds/app-admin/ansible/ansible-9999.ebuild,v 1.0 2012/04/17 13:25:58 uu Exp $

EAPI="4"

EGIT_REPO_URI="git://github.com/ansible/ansible.git"
EGIT_BRANCH="devel"

inherit git-2 distutils
SRC_URI=""

DESCRIPTION="Ansible is a radically simple deployment, model-driven configuration management, and command execution framework. "
HOMEPAGE="http://ansible.github.com/"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
LICENSE="GPL-3"
SLOT="0"
IUSE="templates"
DEPEND="${RDEPEND}
		templates? ( dev-python/jinja )
		dev-python/paramiko
		dev-python/pyyaml
"
src_unpack() {
	git-2_src_unpack
}

src_compile() {
	distutils_src_compile
}

src_install() {
	distutils_src_install
	dodir /usr/share/ansible
	insinto /usr/share/ansible
	insopts -m0655
	doins library/*
	dodoc COPYING 
	ewarn "You have to create hosts file for user:"
	ewarn "		echo \"127.0.0.1\" > ~/ansible_hosts"
	ewarn "or global:"
	ewarn "		echo \"127.0.0.1\" > /etc/ansible/hosts"
	ewarn ""
	ewarn "More info on http://ansible.github.com/gettingstarted.html"
}

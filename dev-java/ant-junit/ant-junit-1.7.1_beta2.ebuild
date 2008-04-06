# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-junit/ant-junit-1.7.0.ebuild,v 1.10 2007/05/12 18:16:10 wltjr Exp $

EAPI=1

inherit ant-tasks

KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"

# xalan is a runtime dependency of the XalanExecutor task
# which was for some reason moved to ant-junit by upstream
DEPEND="dev-java/junit:0"
RDEPEND="${DEPEND}
	dev-java/xalan:0"

src_compile() {
	eant jar-junit
}

src_install() {
	ant-tasks_src_install
	java-pkg_register-dependency xalan
}

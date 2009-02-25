# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT=2.4
inherit java-pkg-2 lucene-contrib

DESCRIPTION="Lucene indexer task for ant"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-java/jtidy
	dev-java/ant-core"
RDEPEND="dev-java/jtidy
	dev-java/ant-core"

LUCENE_EXTRA_DEPS="jtidy,ant-core"

src_install() {
	lucene-contrib_src_install
	java-pkg_register-ant-task
}

# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 wagon

DESCRIPTION=""
# svn co http://svn.apache.org/repos/asf/maven/wagon/tags/wagon-1.0-alpha-4/wagon-providers/wagon-ssh/ wagon-ssh-1.0-alpha-4

SLOT="1"
KEYWORDS="~x86"
IUSE="doc source test"

RDEPEND="=dev-java/wagon-provider-api-1*
	dev-java/plexus-utils
	dev-java/jsch"

src_unpack() {
	wagon_src_unpack
}

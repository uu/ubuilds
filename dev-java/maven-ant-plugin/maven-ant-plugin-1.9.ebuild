# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit maven-plugin-2

DESCRIPTION="Ant plugin for Maven"
KEYWORDS="~x86"

RDEPEND="dev-java/commons-jelly-tags-xml"
DEPEND="${RDEPEND}"

src_unpack(){
	unpack ${@}
	java-maven-2-rewrite_build_xml
}


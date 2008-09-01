# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit java-virtuals-2

DESCRIPTION="Virtual for Java API for XML Processing (JAXP)"
HOMEPAGE="http://www.gentoo.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND="|| (
			=virtual/jdk-1.5*
			dev-java/gnu-jaxp
		)
		>=dev-java/java-config-2.1.6"

JAVA_VIRTUAL_PROVIDES="gnu-jaxp"
JAVA_VIRTUAL_VM="icedtea6 gcj-jdk jamvm cacao sun-jdk-1.5 ibm-jdk-bin-1.5"

# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit java-virtuals-2

DESCRIPTION="Virtual for Javadoc"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	|| (
		>=virtual/jdk-1.5
		dev-java/gjdoc:0
	)
	>=dev-java/java-config-2.1.8"

JAVA_VIRTUAL_PROVIDES="sun-jdk gjdoc"

JAVA_VIRTUAL_VM=">=virtual/jdk-1.5"
JAVA_VIRTUAL_VM_CLASSPATH="/lib/tools.jar"

#JAVA_VIRTUAL_VM=">=virtual/jdk-1.5"

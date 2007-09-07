# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/aspectj/aspectj-1.2-r2.ebuild,v 1.3 2007/04/22 14:04:39 caster Exp $

inherit eutils java-virtuals-2

DESCRIPTION="This is a virtual for Javadoc"

SRC_URI=""

HOMEPAGE="http://www.gentoo.org/"

DEPEND=">=virtual/jdk-1.5"

RDEPEND=">=virtual/jdk-1.5"

LICENSE="as-is"
KEYWORDS="~x86 ~ppc ~amd64"

SLOT="0"

JAVA_VIRTUAL_VM=">=virtual/jdk-1.5"
JAVA_VIRTUAL_VM_CLASSPATH="/lib/tools.jar"

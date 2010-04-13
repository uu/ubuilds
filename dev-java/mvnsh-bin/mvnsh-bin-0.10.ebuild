# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/maven-bin/maven-bin-2.1.0.ebuild,v 1.1 2009/05/12 19:33:02 ali_bush Exp $

inherit java-pkg-2

DESCRIPTION="Project Management and Comprehension Tool for Java"
SRC_URI="http://repo2.maven.org/maven2/org/sonatype/maven/shell/mvnsh-assembly/0.10/mvnsh-assembly-0.10-runtime.zip"
HOMEPAGE="http://shell.sonatype.org/"
LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jdk-1.5"
IUSE=""

S="${WORKDIR}/mvnsh-0.10/"

src_unpack() {
	unpack ${A}

	rm -v "${S}"/bin/*.bat || die
	rm -v "${S}"/bin/mvn || die
	chmod 755 "${S}"/bin/* || die
	chmod 644 "${S}"/lib/*.jar || die
}

# TODO we should use jars from packages, instead of what is bundled
src_install() {
	dodir /usr/share/mvnsh-bin || die
	cp -Rp lib "${D}"/usr/share/mvnsh-bin/ || die

	java-pkg_regjar "${D}"/usr/share/mvnsh-bin/lib/*.jar

	dobin bin/mvnsh
	dosed "s:SHELL_HOME=.*:SHELL_HOME=/usr/share/mvnsh-bin:g" /usr/bin/mvnsh

	dodoc LICENSE.txt NOTICE.txt README.txt || die

	insinto /etc
	doins etc/mvnsh.profile
}

# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils

DESCRIPTION="Mail filter based on the Sendmail Milter"
HOMEPAGE="https://www.mailmunge.org/"
SRC_URI="https://www.mailmunge.org/static/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="mail-filter/libmilter"
RDEPEND="dev-lang/perl
		acct-user/mailmunge
		acct-group/mailmunge
		dev-perl/MIME-tools
		dev-perl/IO-Socket-SSL
		virtual/perl-Time-Local
		dev-perl/File-Find-Rule
		dev-perl/Test-Deep
		dev-perl/Unix-Syslog
		dev-perl/Mail-DKIM
		dev-perl/HTML-Parser
		virtual/mta"

src_configure(){
	econf --with-perlinstalldirs=vendor
}

src_install() {
	emake DESTDIR=${D} install
	keepdir /var/spool/mailmunge
	keepdir /var/spool/mm-quarantine
}

EAPI=5

inherit git-2 eutils

DESCRIPTION="MySQL FDW (Foreign Data Wrapper) for PostgreSQL"
HOMEPAGE="http://pgxn.org/dist/mysql_fdw/"

SRC_URI=""
EGIT_REPO_URI="git://github.com/EnterpriseDB/mysql_fdw.git"
EGIT_BRANCH="master"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

src_compile() {
	emake USE_PGXS=1
}

src_install() {
	pg_libdir=$(pg_config --pkglibdir)
	insinto ${pg_libdir}
	doins ${PN}.so

	pg_shared=$(pg_config --sharedir)
	insinto ${pg_shared}/extension
	doins ${PN}.control
	doins sql/${PN}.sql
	
	dodoc README.md 
}


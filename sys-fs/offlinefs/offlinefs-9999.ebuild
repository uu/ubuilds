DESCRIPTION="A FUSE-based offline filesystem" 
HOMEPAGE="http://offlinefs.sourceforge.net" 
inherit subversion autotools 
ESVN_REPO_URI="http://offlinefs.svn.sourceforge.net/svnroot/offlinefs/ofs/trunk" 
ESVN_PROJECT="offlinefs" 

LICENSE="GPL-2" 
SLOT="0" 
KEYWORDS="~amd64 ~x86" 

DEPEND="=sys-fs/fuse-2* 
        >=dev-libs/confuse-2.6" 
RDEPEND="${DEPEND}" 

src_unpack() { 
        subversion_src_unpack 
        cd "${S}" 
        sed -i s/"\(myexecpdir= \)\$(DESTDIR)"/"\1"/g src/Makefile.am || die "patching src/Makefile.am failed" 
		#sed -i s/"\(myexecpdir = \)\$(DESTDIR)"/"\1"/g mounthelper/Makefile.am || die "patching mounthelper/Makefile.am failed" 
        eautoreconf 
        econf 
} 

src_compile() { 
        emake || die 
} 

src_install() { 
        dodir sbin 
        emake DESTDIR="${D}" install || die "Install failed" 
}

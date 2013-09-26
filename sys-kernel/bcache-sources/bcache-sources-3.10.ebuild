# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
SLOT="0"
ETYPE="sources"

#CKV=`date +%F`
CKV="3.10.0"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE="0"

inherit kernel-2 git-2
detect_version

K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
K_SECURITY_UNSUPPORTED="1"

EGIT_REPO_URI="http://evilpiepirate.org/git/linux-bcache.git"
EGIT_PROJECT="linux-bcache"
#EGIT_UPSTREAM="bcache-3.2"
EGIT_BRANCH="bcache-3.10-stable"

DESCRIPTION="Full sources for the Linux kernel with bcache patch"
HOMEPAGE="http://www.kernel.org"
SRC_URI=""

KEYWORDS="~amd64 ~x86"
IUSE="tools"

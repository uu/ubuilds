# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eclipse-rcp

KEYWORDS="~x86"
IUSE=""

DEPEND="=dev-java/swt-3*
	=dev-java/eclipse-equinox-common-3*
	=dev-java/eclipse-core-commands-3*"
RDEPEND="${DEPEND}"

RCP_ROOT="org.eclipse.rcp.source_3.2.2.r322_v20070104-8pcviKVqd8J7C1U"
RCP_PACKAGE_DIR="org.eclipse.jface_3.2.2.M20061214-1200"
RCP_EXTRA_DEPS="swt-3,eclipse-equinox-common-3,eclipse-core-commands-3"

# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eclipse-rcp

KEYWORDS="~x86"
IUSE=""

DEPEND="=dev-java/swt-3*
	=dev-java/eclipse-osgi-3*
	=dev-java/eclipse-equinox-common-3*
	=dev-java/eclipse-equinox-preferences-3*
	=dev-java/eclipse-core-runtime-3*
	=dev-java/eclipse-jface-3*
	=dev-java/eclipse-ui-workbench-3*"
RDEPEND="${DEPEND}"

RCP_ROOT="org.eclipse.rcp.source_3.2.2.r322_v20090104-8pcviKVqd8J7C1U"
RCP_PACKAGE_DIR="org.eclipse.ui_3.2.1.M20091108"
RCP_EXTRA_DEPS="swt-3,eclipse-osgi-3,eclipse-equinox-common-3,eclipse-equinox-preferences-3,eclipse-core-runtime-3,eclipse-jface-3,eclipse-ui-workbench-3"

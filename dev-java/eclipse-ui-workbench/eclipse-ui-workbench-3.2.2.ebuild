# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eclipse-rcp

KEYWORDS="~x86"
IUSE=""

DEPEND="=dev-java/swt-3*
	=dev-java/icu4j-3.4*
	=dev-java/eclipse-osgi-3*
	=dev-java/eclipse-equinox-common-3*
	=dev-java/eclipse-core-jobs-3*
	=dev-java/eclipse-core-commands-3*
	=dev-java/eclipse-core-contenttype-3*
	=dev-java/eclipse-core-expressions-3*
	=dev-java/eclipse-equinox-registry-3*
	=dev-java/eclipse-equinox-preferences-3*
	=dev-java/eclipse-core-runtime-3*
	=dev-java/eclipse-jface-3*
	=dev-java/eclipse-help-3*"
RDEPEND="${DEPEND}"

RCP_ROOT="org.eclipse.rcp.source_3.2.2.r322_v20070104-8pcviKVqd8J7C1U"
RCP_PACKAGE_DIR="org.eclipse.ui.workbench_3.2.2.M20070119-0800"
RCP_EXTRA_DEPS="swt-3,icu4j-3.4,eclipse-osgi-3,eclipse-equinox-common-3,eclipse-core-jobs-3,eclipse-core-commands-3,eclipse-core-contenttype-3,eclipse-core-expressions-3,eclipse-equinox-registry-3,eclipse-equinox-preferences-3,eclipse-core-runtime-3,eclipse-jface-3,eclipse-help-3"

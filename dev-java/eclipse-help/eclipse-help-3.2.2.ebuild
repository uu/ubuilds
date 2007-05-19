# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eclipse-rcp

KEYWORDS="~x86"
IUSE=""

DEPEND="=dev-java/icu4j-3.4*
	=dev-java/eclipse-osgi-3*
	=dev-java/eclipse-equinox-common-3*
	=dev-java/eclipse-equinox-registry-3*
	=dev-java/eclipse-core-contenttype-3*
	=dev-java/eclipse-core-runtime-3*"
RDEPEND="${DEPEND}"

RCP_ROOT="org.eclipse.rcp.source_3.2.2.r322_v20070104-8pcviKVqd8J7C1U"
RCP_PACKAGE_DIR="org.eclipse.help_3.2.2.R322_v20061213"
RCP_EXTRA_DEPS="icu4j-3.4,eclipse-osgi-3,eclipse-equinox-common-3,eclipse-equinox-registry-3,eclipse-core-contenttype-3,eclipse-core-runtime-3"

# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eclipse-rcp

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="=dev-java/swt-3*
	=dev-java/eclipse-equinox-common-${SLOT}*
	=dev-java/eclipse-core-commands-${SLOT}*
	=dev-java/eclipse-osgi-${SLOT}*"
RDEPEND="${DEPEND}"

RCP_ROOT="org.eclipse.rcp.source_3.3.2.R33x_r20071022-8y8eE9CEV3FspP8HJrY1M2dS"
RCP_PACKAGE_DIR="org.eclipse.jface_3.3.1.M20070910-0800b"
RCP_EXTRA_DEPS="swt-3,eclipse-equinox-common-${SLOT},eclipse-core-commands-${SLOT},eclipse-osgi-${SLOT}"

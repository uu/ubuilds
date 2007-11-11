# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eclipse-rcp

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="=dev-java/eclipse-osgi-${SLOT}*"
RDEPEND="${DEPEND}"

RCP_ROOT="org.eclipse.rcp.source_3.3.2.R33x_r20071022-8y8eE9CEV3FspP8HJrY1M2dS"
RCP_PACKAGE_DIR="org.eclipse.equinox.common_3.3.0.v20070426"
RCP_EXTRA_DEPS="eclipse-osgi-${SLOT}"

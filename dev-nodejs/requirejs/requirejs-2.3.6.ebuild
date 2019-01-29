# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.8.0"
NODE_MODULE_EXTRA_FILES="bin/r.js require.js"
#NODE_MODULE_DEPEND="uglify-to-browserify:1.0.2
#	source-map:0.5.7"

inherit node-module

DESCRIPTION="JavaScript file and module loader"

LICENSE="CC0-1.0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID=-1
ACCT_USER_GROUPS=( leilfs )
ACCT_USER_HOME="/etc/leilfs"
ACCT_USER_HOME_OWNER="leilfs:leilfs"

acct-user_add_deps

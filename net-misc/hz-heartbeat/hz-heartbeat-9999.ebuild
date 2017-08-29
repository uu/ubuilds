# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby22 ruby23 ruby24"
inherit ruby-fakegem git-r3

DESCRIPTION="Heartbeat is a rather simple daemon which pings a Hetzner Failover IP"

EGIT_REPO_URI="https://github.com/mrkamel/heartbeat.git"
EGIT_BRANCH="master"
EGIT_CHECKOUT_DIR="${WORKDIR}/all"

HOMEPAGE="https://github.com/mrkamel/heartbeat"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-ruby/hashr
dev-ruby/rake
dev-ruby/json
dev-ruby/httparty"

RDEPEND="${DEPEND}"
#S="${S}/${P}"

ruby_add_bdepend "dev-ruby/bundler"


#src_prepare() {
#	pwd
#	default
#}

#each_ruby_install() {
#	doruby "${S}"/lib/failover_ip.rb
#	doruby "${S}"/lib/hooks.rb
#	dobin "${S}"/bin/hearbeat
#}

all_ruby_prepare() {
	if [ -f Gemfile.lock ]; then
		rm  Gemfile.lock || die
	fi
	sed -i '/mocha/d' Gemfile || die
	rm bin/debian* || die


#	mkdir bin
#	ln -s ../samples/disassemble.rb ./bin/disassemble
#	ln -s ../samples/disassemble-gui.rb ./bin/disassemble-gui
}

each_ruby_prepare() {
	if [ -f Gemfile ]
	then
			BUNDLE_GEMFILE=Gemfile ${RUBY} -S bundle install --local || die
			BUNDLE_GEMFILE=Gemfile ${RUBY} -S bundle check || die
	fi
}

all_ruby_install() {
	#all_fakegem_install
	#rm /usr/bin/heartbeat
	ruby_fakegem_binwrapper heartbeat ${PN}
	dodir /etc/${PN}/hooks/{after,before}
	keepdir /etc/${PN}/hooks/{after,before}
	insinto /etc/${PN}
	doins config/heartbeat.yml
	
	newinitd "${FILESDIR}/${PN}.init" hz-heartbeat

	#ruby_fakegem_binwrapper disassemble-gui
}



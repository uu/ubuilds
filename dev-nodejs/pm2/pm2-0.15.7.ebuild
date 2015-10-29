EAPI=5

inherit npm-2

DESCRIPTION="Production process manager for Node.JS applications. Perfectly designed for microservice architecture."

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=net-libs/nodejs-4.0.0
	  dev-nodejs/async
	  dev-nodejs/chalk
	  dev-nodejs/chokidar
	  dev-nodejs/cli-table
	  dev-nodejs/coffee-script
	  dev-nodejs/commander      
	  dev-nodejs/cron      
	  dev-nodejs/debug      
	  dev-nodejs/eventemitter2
	  dev-nodejs/moment      
	  dev-nodejs/nssocket      
	  dev-nodejs/pidusage      
	  dev-nodejs/pmx
	  dev-nodejs/vizion      
	  dev-nodejs/pm2-axon      
	  dev-nodejs/pm2-axon-rpc
	  dev-nodejs/pm2-deploy
	  dev-nodejs/pm2-multimeter
	  dev-nodejs/safe-clone-deep
	  dev-nodejs/shelljs      
	  dev-nodejs/isbinaryfile
	  dev-nodejs/blessed      
	  dev-nodejs/semver      
	  dev-nodejs/mkdirp      
	${DEPEND}"

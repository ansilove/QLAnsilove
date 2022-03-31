APP?=QLAnsilove
COMMIT_SHA=$(shell git rev-parse --short HEAD)

.DEFAULT_GOAL := help

.PHONY: daemon-restart
## daemon-restart: restart the macOS quicklook daemon
daemon-restart:
	qlmanage -r

.PHONY: list-types
## list-types: list all registered file types for QLAnsilove
list-types:
	qlmanage -m plugins | grep QLAnsi

.PHONY: framework
## framework: output install name of the AnsiLove framework
framework:
	otool -D /Developer/github.com/blocktronics/QLAnsi/QLAnsi/Frameworks/AnsiLove.framework/AnsiLove 

.PHONY: install
## install: CLI install of QLAnsilove
install:
	install_name_tool -id '@rpath/AnsiLove.Framework/AnsiLove' AnsiLove.framework/AnsiLove

.PHONY: help
## help: print this help message
help:
	@echo "QLAnsilove Make Commands\n\nUsage: \n  make [command]\n\nAvailable Commands:"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'
	@echo "\nPlease note many of these commands are reference and not meant to be used"
	@echo "other than for development work."

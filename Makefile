NOW=$(shell date -u)

.PHONY: server
server:
	hugo server --disableFastRender

.PHONY: build-and-push
build-and-push: build
	cd public && git add . && git commit -m "updates from $(NOW)" && git push origin master

.PHONY: build
build:
	hugo build --gc --minify --cleanDestinationDir --forceSyncStatic -d ../ilikeorangutans.github.com/


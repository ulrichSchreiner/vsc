.ONESHELL:
TAGVERSION := $(shell git describe --tags | sed 's/\(.*\)-.*/\1/')
VSC_MAIN := 1.35
VSC_MINOR := 0
VSC_VERSION := $(VSC_MAIN).$(VSC_MINOR)
INSIDER := https://vscode-update.azurewebsites.net/latest/linux-deb-x64/insider
STABLE := https://update.code.visualstudio.com/$(VSC_VERSION)/linux-deb-x64/stable

.phony:
build-stable:
	docker build $(USEBUILDCACHE) \
		-t quay.io/ulrichschreiner/vsc:latest \
		-t quay.io/ulrichschreiner/vsc:$(VSC_VERSION) \
		-t quay.io/ulrichschreiner/vsc:$(VSC_MAIN) \
		--build-arg VSC_URL=$(STABLE) \
		--build-arg VSC_EXT=\
		--build-arg CODE_START=/usr/bin/code \
		.

.phony:
build-thin:
	@cd thin
	docker build $(USEBUILDCACHE) \
		-t quay.io/ulrichschreiner/vsc-thin:latest \
		-t quay.io/ulrichschreiner/vsc-thin:$(VSC_VERSION) \
		-t quay.io/ulrichschreiner/vsc-thin:$(VSC_MAIN) \
		--build-arg VSC_URL=$(STABLE) \
		--build-arg VSC_EXT= \
		--build-arg CODE_START=/usr/bin/code \
		.

.phony:
push:
	docker push quay.io/ulrichschreiner/vsc:latest
	docker push quay.io/ulrichschreiner/vsc:$(VSC_VERSION)
	docker push quay.io/ulrichschreiner/vsc:$(VSC_MAIN)

.phony:
push-thin:
	docker push quay.io/ulrichschreiner/vsc-thin:latest
	docker push quay.io/ulrichschreiner/vsc-thin:$(VSC_VERSION)
	docker push quay.io/ulrichschreiner/vsc-thin:$(VSC_MAIN)

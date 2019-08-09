.ONESHELL:
TAGVERSION := $(shell git describe --tags | sed 's/\(.*\)-.*/\1/')
VSC_MAIN := 1.37
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
		.

.phony:
tag:
	git tag -am $(VSC_VERSION) $(VSC_VERSION)

.phony:
build-thin:
	@cd thin
	docker build $(USEBUILDCACHE) \
		-t quay.io/ulrichschreiner/vsc-thin:latest \
		-t quay.io/ulrichschreiner/vsc-thin:$(VSC_VERSION) \
		-t quay.io/ulrichschreiner/vsc-thin:$(VSC_MAIN) \
		--build-arg VSC_URL=$(STABLE) \
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

.phony:
login:
	docker login -u $(QUAY_USER) -p $(QUAY_PWD) quay.io

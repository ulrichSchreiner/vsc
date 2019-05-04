.ONESHELL:
TAGVERSION := $(shell git describe --tags | sed 's/\(.*\)-.*/\1/')
VSC_MAIN := 1.33
VSC_MINOR := 1
VSC_VERSION := $(VSC_MAIN).$(VSC_MINOR)
INSIDER := https://vscode-update.azurewebsites.net/latest/linux-deb-x64/insider
STABLE := https://update.code.visualstudio.com/$(VSC_VERSION)/linux-deb-x64/stable

.phony:
build-stable:
	docker build \
		-t quay.io/ulrichschreiner/vsc:latest \
		-t quay.io/ulrichschreiner/vsc:$(VSC_VERSION) \
		-t quay.io/ulrichschreiner/vsc:$(TAGVERSION) \
		-t quay.io/ulrichschreiner/vsc:$(VSC_MAIN) \
		--build-arg VSC_URL=$(STABLE) \
		.

.phony:
build-insider:
	docker build -t quay.io/ulrichschreiner/vsc:insider \
		--build-arg VSC_URL=$(INSIDER) \
		.

.phony:
push:
	docker push quay.io/ulrichschreiner/vsc:latest
	docker push quay.io/ulrichschreiner/vsc:$(VSC_VERSION)
	docker push quay.io/ulrichschreiner/vsc:$(VSC_MAIN)
	docker push quay.io/ulrichschreiner/vsc:$(TAGVERSION)

.phony:
push-insider:
	docker push quay.io/ulrichschreiner/vsc:insider

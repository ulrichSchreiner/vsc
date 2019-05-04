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
		-t ulrichschreiner/vsc:latest \
		-t ulrichschreiner/vsc:$(VSC_VERSION) \
		-t ulrichschreiner/vsc:$(TAGVERSION) \
		-t ulrichschreiner/vsc:$(VSC_MAIN) \
		--build-arg VSC_URL=$(STABLE) \
		.

.phony:
build-insider:
	docker build -t ulrichschreiner/vsc:insider \
		--build-arg VSC_URL=$(INSIDER) \
		.

.phony:
push:
	docker push ulrichschreiner/vsc:latest
	docker push ulrichschreiner/vsc:$(VSC_VERSION)
	docker push ulrichschreiner/vsc:$(VSC_MAIN)
	docker push ulrichschreiner/vsc:$(TAGVERSION)

.phony:
push-insider:
	docker push ulrichschreiner/vsc:insider

# Image URL to use all building/pushing image targets
REGISTRY ?= quay.io
REPOSITORY ?= $(REGISTRY)/eformat

REALODER_VERSION ?= v0.0.114
RELOADER_IMG := $(REPOSITORY)/reloader:$(REALODER_VERSION)
UBI_TAG ?= 8.6-903
UBI_IMG ?= registry.access.redhat.com/ubi8/ubi:$(UBI_TAG)
GO_IMG ?= registry.redhat.io/rhel8/go-toolset:1.17.7-13

podman-build-reloader: export ARCH=amd64
podman-build-reloader: export BUILDER_IMAGE=$(GO_IMG)
podman-build-reloader: export BASE_IMAGE=$(UBI_IMG)
podman-build-reloader: export VERSION=$(REALODER_VERSION)
podman-build-reloader: export DOCKER_IMAGE=$(REPOSITORY)/reloader

podman-login:
	@podman login -u $(DOCKER_USER) -p $(DOCKER_PASSWORD) $(REGISTRY)

# upstream
podman-build-reloader-from-upstream:
	rm -rf reloader/reloader && git clone https://github.com/eformat/reloader.git reloader/reloader
	cd reloader && make podman-build-image

# checked in code
podman-build-reloader:
	cd reloader && make podman-build-image

podman-push-reloader: podman-build-reloader
	podman push ${RELOADER_IMG}

build: podman-build-reloader

push: podman-push-reloader

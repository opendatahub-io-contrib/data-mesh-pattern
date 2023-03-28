# Image URL to use all building/pushing image targets
REGISTRY ?= quay.io
REPOSITORY ?= $(REGISTRY)/eformat

ELYRA_VERSION_1 ?= 0.1.5
ELYRA_VERSION_2 ?= 0.2.1

ELYRA_BASE_IMG_1 := $(REPOSITORY)/elyra-base:$(ELYRA_VERSION_1)
ELYRA_BASE_IMG_2 := $(REPOSITORY)/elyra-base:$(ELYRA_VERSION_2)

podman-login:
	@podman login -u $(DOCKER_USER) -p $(DOCKER_PASSWORD) $(REGISTRY)

podman-build-elyra-base-1:
	podman build . -t ${ELYRA_BASE_IMG_1} -f base/Dockerfile

podman-push-elyra-base-1: podman-build-elyra-base
	podman push ${ELYRA_BASE_IMG_1}

podman-build-elyra-base-2:
	podman build . -t ${ELYRA_BASE_IMG_2} -f base/Dockerfile

podman-push-elyra-base-2: podman-build-elyra-base
	podman push ${ELYRA_BASE_IMG_2}

build: podman-build-elyra-base-1 podman-build-elyra-base-2

push: podman-push-elyra-base-1 podman-push-elyra-base-2

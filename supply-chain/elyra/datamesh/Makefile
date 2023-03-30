# Image URL to use all building/pushing image targets
REGISTRY ?= quay.io
REPOSITORY ?= $(REGISTRY)/eformat

DATAMESH_VERSION ?= 1.0.0

DATAMESH_IMG := $(REPOSITORY)/datamesh-elyra:$(DATAMESH_VERSION)

podman-login:
	@podman login -u $(DOCKER_USER) -p $(DOCKER_PASSWORD) $(REGISTRY)

podman-build-elyra-datamesh:
	podman build . -t ${DATAMESH_IMG} -f Dockerfile

podman-push-elyra-datamesh: podman-build-elyra-datamesh
	podman push ${DATAMESH_IMG}

build: podman-build-elyra-datamesh

push: podman-push-elyra-datamesh

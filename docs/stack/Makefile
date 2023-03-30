REGISTRY ?= quay.io
REPOSITORY ?= $(REGISTRY)/eformat/stack

VERSION=$(shell cat VERSION)
IMG := $(REPOSITORY):$(VERSION)

# Podman Login
podman-login:
	@podman login -u $(DOCKER_USER) -p $(DOCKER_PASSWORD) $(REGISTRY)

# Build the oci image
podman-build:
	podman build . -t ${IMG} -f Dockerfile

# Push the oci image
podman-push: podman-build
	podman push ${IMG}

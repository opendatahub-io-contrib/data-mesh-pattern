# Hacks
OS := $(if $(GOOS),$(GOOS),$(shell go env GOOS))
ARCH := $(if $(GOARCH),$(GOARCH),$(shell go env GOARCH))
BASE_IMAGE ?= registry.access.redhat.com/ubi8/ubi:8.7-1112
BUILDER_IMAGE ?= registry.redhat.io/rhel8/go-toolset:1.17.12-3
IMAGE=quay.io/eformat/git-sync
TAG=3.6.6

podman-build-image:
	podman build \
		--platform ${OS}/${ARCH} \
		--build-arg GOARCH=$(ARCH) \
		--build-arg BUILDER_IMAGE=$(BUILDER_IMAGE) \
		--build-arg BASE_IMAGE=${BASE_IMAGE} \
		-t $(IMAGE):$(TAG) \
		--load \
		-f Dockerfile.rh \
		.

podman-push: podman-build-image
	podman push $(IMAGE):$(TAG)

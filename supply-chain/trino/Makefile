# Image URL to use all building/pushing image targets
REGISTRY ?= quay.io
REPOSITORY ?= $(REGISTRY)/eformat

TRINO_VERSION ?= 390
PROMETHEUS_VERSION ?= 0.17.0
HADOOP_VERSION ?= 3.3.1
METASTORE_VERSION ?= 3.1.2
UBI_TAG ?= 8.6-903
UBI_IMG ?= registry.access.redhat.com/ubi8/ubi:$(UBI_TAG)
BASE_DEP_IMG := $(REPOSITORY)/trino-dep:$(TRINO_VERSION)
TRINO_IMG := $(REPOSITORY)/ubi-trino:$(TRINO_VERSION)
HIVE_IMG := $(REPOSITORY)/ubi-hive:$(METASTORE_VERSION)

podman-login:
	@podman login -u $(DOCKER_USER) -p $(DOCKER_PASSWORD) $(REGISTRY)

podman-build-base-dep:
	podman build --from ${UBI_IMG} -t ${BASE_DEP_IMG} --build-arg TRINO_VERSION=$(TRINO_VERSION) --build-arg PROMETHEUS_VERSION=$(PROMETHEUS_VERSION) --build-arg HADOOP_VERSION=$(HADOOP_VERSION) --build-arg METASTORE_VERSION=$(METASTORE_VERSION) . -f Dockerfile.dep

podman-push-base-dep: podman-build-base-dep
	podman push ${BASE_DEP_IMG}

podman-build-trino: #podman-build-base-dep
	podman build --from ${BASE_DEP_IMG} -t ${TRINO_IMG} --build-arg TRINO_VERSION=$(TRINO_VERSION) --build-arg PROMETHEUS_VERSION=$(PROMETHEUS_VERSION) . -f trino/Dockerfile

podman-push-trino: podman-build-trino
	podman push ${TRINO_IMG}

podman-build-hive: #podman-build-base-dep
	podman build --from ${BASE_DEP_IMG} -t ${HIVE_IMG} --build-arg HADOOP_VERSION=$(HADOOP_VERSION) --build-arg PROMETHEUS_VERSION=$(PROMETHEUS_VERSION) --build-arg METASTORE_VERSION=$(METASTORE_VERSION) . -f hive/Dockerfile

podman-push-hive: podman-build-hive
	podman push ${HIVE_IMG}

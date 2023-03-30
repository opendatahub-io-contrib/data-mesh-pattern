# Image URL to use all building/pushing image targets
REGISTRY ?= quay.io
REPOSITORY ?= $(REGISTRY)/eformat

SPARK_VERSION ?= 3.3.0
HADOOP_VERSION ?= 3
UBI_TAG ?= 8.6-903
UBI_IMG ?= registry.access.redhat.com/ubi8/ubi:$(UBI_TAG)
GO_BUILDER_IMG := registry.access.redhat.com/ubi8/go-toolset:1.17.7-13.1655148239
S2I_ELYRA_TAG ?= v0.1.3
S2I_ELYRA_IMG ?= quay.io/thoth-station/s2i-lab-elyra:$(S2I_ELYRA_TAG)
SPARK_BASE_IMG := spark-base:$(SPARK_VERSION)
SPARK_BASE_DEP_IMG := $(REPOSITORY)/spark-base-dep:$(SPARK_VERSION)
SPARK_RAD_IMG := $(REPOSITORY)/spark-rad:$(SPARK_VERSION)
SPARK_GOOGLE_IMG := $(REPOSITORY)/spark-google:$(SPARK_VERSION)
SPARK_GOOGLE_OP_IMG := $(REPOSITORY)/spark-google-operator:$(SPARK_VERSION)
SPARK_ELYRA_SPARK_IMG := $(REPOSITORY)/elyra-spark:$(SPARK_VERSION)
SPARK_HISTORY_BASE_DEP_IMG := $(REPOSITORY)/spark-history-dep:$(SPARK_VERSION)
SPARK_HISTORY_IMG := $(REPOSITORY)/spark-history:$(SPARK_VERSION)

podman-login:
	@podman login -u $(DOCKER_USER) -p $(DOCKER_PASSWORD) $(REGISTRY)

podman-build-base-dep:
	podman build --from ${UBI_IMG} -t ${SPARK_BASE_DEP_IMG} --build-arg SPARK_VERSION=$(SPARK_VERSION) --build-arg HADOOP_VERSION=$(HADOOP_VERSION) . -f base/Dockerfile.dep

podman-push-base-dep: podman-build-base-dep
	podman push ${SPARK_BASE_DEP_IMG}

podman-build-base:
	podman build --from ${SPARK_BASE_DEP_IMG} --build-arg SPARK_VERSION=$(SPARK_VERSION) --build-arg HADOOP_VERSION=$(HADOOP_VERSION) . -t ${SPARK_BASE_IMG} -f base/Dockerfile

podman-build-rad: podman-build-base
	podman build . -t ${SPARK_RAD_IMG} --from ${SPARK_BASE_IMG} --build-arg SPARK_VERSION=$(SPARK_VERSION) --build-arg HADOOP_VERSION=$(HADOOP_VERSION) -f radanalyticsio/Dockerfile

podman-push-rad: podman-build-rad
	podman push ${SPARK_RAD_IMG}

podman-build-google: podman-build-base
	podman build . -t ${SPARK_GOOGLE_IMG} --from ${SPARK_BASE_IMG} --build-arg SPARK_VERSION=$(SPARK_VERSION) --build-arg HADOOP_VERSION=$(HADOOP_VERSION) -f google/Dockerfile

podman-push-google: podman-build-google
	podman push ${SPARK_GOOGLE_IMG}

# latest google source code
podman-build-google-operator-from-upstream:
	rm -rf google/spark-on-k8s-operator && git clone https://github.com/GoogleCloudPlatform/spark-on-k8s-operator.git google/spark-on-k8s-operator
	podman build --from ${GO_BUILDER_IMG} --build-arg SPARK_IMAGE=${SPARK_GOOGLE_IMG} . -t ${SPARK_GOOGLE_OP_IMG} -f google/Dockerfile.operator

# checked in google source code
podman-build-google-history-base-dep:
	podman build --from ${UBI_IMG} -t ${SPARK_HISTORY_BASE_DEP_IMG} . -f google/Dockerfile.dep

podman-push-google-history-base-dep: podman-build-google-history-base-dep
	podman push ${SPARK_HISTORY_BASE_DEP_IMG}

podman-build-google-operator: podman-build-google
	podman build --from ${GO_BUILDER_IMG} --build-arg SPARK_IMAGE=${SPARK_GOOGLE_IMG} . -t ${SPARK_GOOGLE_OP_IMG} -f google/Dockerfile.operator

podman-push-google-operator: podman-build-google-operator
	podman push ${SPARK_GOOGLE_OP_IMG}

podman-build-history: podman-build-base
	podman build . -t ${SPARK_HISTORY_IMG} --from ${SPARK_BASE_IMG} --build-arg SPARK_VERSION=$(SPARK_VERSION) --build-arg HADOOP_VERSION=$(HADOOP_VERSION) -f google/Dockerfile.historyserver

podman-push-history: podman-build-google
	podman push ${SPARK_HISTORY_IMG}

podman-build-elyra-spark:
	podman build --from ${S2I_ELYRA_IMG} --build-arg SPARK_VERSION=$(SPARK_VERSION) --build-arg HADOOP_VERSION=$(HADOOP_VERSION) . -t ${SPARK_ELYRA_SPARK_IMG} -f elyra-spark/Dockerfile

podman-push-elyra-spark: podman-build-elyra-spark
	podman push ${SPARK_ELYRA_SPARK_IMG}

build: podman-build-rad podman-build-google-operator podman-build-elyra-spark podman-build-history podman-build-base-dep podman-build-google-history-base-dep

push: podman-push-rad podman-push-google podman-push-google-operator podman-push-elyra-spark podman-push-history podman-push-base-dep podman-push-google-history-base-dep

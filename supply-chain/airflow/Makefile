# Image URL to use all building/pushing image targets
REGISTRY ?= quay.io
REPOSITORY ?= $(REGISTRY)/eformat

AIRFLOW_VERSION ?= 2.5.1
PYTHON_TAG ?= 1-117.1674497496
PYTHON_IMG ?= registry.access.redhat.com/ubi8/python-38:$(PYTHON_TAG)
AIRFLOW_BASE_IMG := localhost/airflow-base:latest
AIRFLOW_RUNNER_IMG := $(REPOSITORY)/airflow-runner:$(AIRFLOW_VERSION)
AIRFLOW_SCHEDULER_IMG := $(REPOSITORY)/airflow-scheduler:$(AIRFLOW_VERSION)
AIRFLOW_WEB_IMG := $(REPOSITORY)/airflow-web:$(AIRFLOW_VERSION)
AIRFLOW_WORKER_IMG := $(REPOSITORY)/airflow-worker:$(AIRFLOW_VERSION)

podman-login:
	@podman login -u $(DOCKER_USER) -p $(DOCKER_PASSWORD) $(REGISTRY)

podman-build-airflow-base:
	podman build --from $(PYTHON_IMG) . -t ${AIRFLOW_BASE_IMG} -f base/Dockerfile

podman-build-airflow-runner: podman-build-airflow-base
	podman build --from $(AIRFLOW_BASE_IMG) . -t ${AIRFLOW_RUNNER_IMG} -f Dockerfile.runner

podman-push-airflow-runner: podman-build-airflow-runner
	podman push ${AIRFLOW_RUNNER_IMG}

podman-build-airflow-scheduler: podman-build-airflow-base
	podman build --from ${AIRFLOW_BASE_IMG} --build-arg AIRFLOW_VERSION=$(AIRFLOW_VERSION) . -t ${AIRFLOW_SCHEDULER_IMG} -f Dockerfile.scheduler

podman-push-airflow-scheduler: podman-build-airflow-scheduler
	podman push ${AIRFLOW_SCHEDULER_IMG}

podman-build-airflow-web: podman-build-airflow-base
	podman build --from ${AIRFLOW_BASE_IMG} --build-arg AIRFLOW_VERSION=$(AIRFLOW_VERSION) . -t ${AIRFLOW_WEB_IMG} -f Dockerfile.web

podman-push-airflow-web: podman-build-airflow-web
	podman push ${AIRFLOW_WEB_IMG}

podman-build-airflow-worker: podman-build-airflow-base
	podman build --from ${AIRFLOW_BASE_IMG} --build-arg AIRFLOW_VERSION=$(AIRFLOW_VERSION) . -t ${AIRFLOW_WORKER_IMG} -f Dockerfile.worker

podman-push-airflow-worker: podman-build-airflow-worker
	podman push ${AIRFLOW_WORKER_IMG}

build: podman-build-airflow-runner podman-build-airflow-scheduler podman-build-airflow-web podman-build-airflow-worker

push: podman-push-airflow-runner podman-push-airflow-scheduler podman-push-airflow-web podman-push-airflow-worker

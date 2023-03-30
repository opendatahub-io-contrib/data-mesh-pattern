# spark images

Spark common base image:

- ubi8
- openjdk11
- python38

The two layered spark runtime images build from this are:

- Rad - spark cluster on demand image
- Google - spark operator image

The Jupyterhub Notebook runner images built from this are

- elyra-spark

See the Makefile for env var overrides i.e.

```bash
REGISTRY=quay.io
REPOSITORY=$(REGISTRY)/eformat
SPARK_VERSION=3.2.0
HADOOP_VERSION=3.2
```

## Build images

Build all images

```bash
make build
```

Base image

```bash
make podman-build-base
```

Rad/Quarkus spark cluster image

```bash
make podman-build-rad
```

Google spark base image

```bash
make podman-build-google
```

Google spark operator image (requires github and golang environment to build)

```bash
make podman-build-google-operator
```

Elyra spark notebook image

```bash
make podman-build-elyra-spark
```

## Push images

Login to your registry and run

Push all images

```bash
make push
```

Individually

```bash
make podman-push-rad
make podman-push-google
make podman-push-google-operator
make podman-push-elyra-spark
```

## Links

Built using these links.

- https://github.com/GoogleCloudPlatform/spark-on-k8s-operator.git
- https://spark.apache.org/docs/latest/running-on-kubernetes.html#docker-images
- https://github.com/masoodfaisal/openshift-spark/blob/master/openshift-spark-build/Dockerfile
- https://github.com/guimou/spark-on-openshift/blob/main/spark-images/pyspark.Dockerfile
- https://github.com/masoodfaisal/ml-workshop/blob/main/notebook-image/elyra-spark3/Dockerfile
- https://github.com/opendatahub-io/s2i-lab-elyra
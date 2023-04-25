# Disconnected Images Supply Chain

To manage supply chain risk, we are building AIMLOPS images using this repo.

### OpenShift Builds

The primary target for these builds is OpenShift. We use OCI image builds from Dockerfiles exclusively. We can also build images for local loop testing (see Makefiles).

The gitops repository references the Dockerfiles in this repo and deploys `BuildConfig` objects in OpenShift, pushing the built images to an internal or external image registry.

`FIXME - Pipelines` - enhance with Tekton.

### Top Level Makefile

We are using GNU make for local loop testing. This repo is set out with a top level Makefile. Each sub folder holds a Makefile as well.

```
.
├── Makefile
├── airflow
└── ...
```

To build all images:

```bash
make build
```

To push (and build) all images

```bash
make push
```

You can override the target registry (as well as other Makefile ARG's) by simply exporting the env.var's

```bash
export REGISTRY=gcr.io
export REPOSITORY=${REGISTRY}/foobarbaz
```

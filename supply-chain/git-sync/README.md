# git-sync

Online build of git-sync. If this needs to be offline, replace the git clone in the Dockerfile with local source code.

- https://github.com/kubernetes/git-sync

```bash
cd git-sync
make podman-build-image
```

See the associated OpenShift build config.

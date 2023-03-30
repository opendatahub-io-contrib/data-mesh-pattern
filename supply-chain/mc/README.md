# mc

Minio Client with certs packaged in.

Build
```bash
docker build --platform linux/amd64 -t mymc -f Dockerfile .
```

Run locally
```bash
docker run -it --entrypoint=bash mymc
```

Setup Connections
```bash
mc alias set dev https://minio:443 dev <password> --api S3v4
```

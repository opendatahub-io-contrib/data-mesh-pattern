# Trino

Trino component installs trino, the Open Source project of Starburst Presto. Trino is a
distributed SQL Analytical database that can integrate with multiple data sources.

## Multiple Hive Catalogs

The list of catalogs can be specified in the `catalogs:` list.

A demo hive s3 catalog is configured by default.

```yaml
catalogs:
  # Hive Demo Catalog
  - name: demo
    enabled: true
    replicaCountHive: 1
```

Matching `hive-s3-secret` entries from Vault (upper case the `name` parameter)

```yaml
  AWS_ACCESS_KEY_ID: <DEMO_HIVE_S3_AWS_ACCESS_KEY_ID>
  AWS_SECRET_ACCESS_KEY: <DEMO_HIVE_S3_AWS_ACCESS_KEY>
  BUCKET: <DEMO_HIVE_S3_BUCKET>
  S3_ENDPOINT: <DEMO_HIVE_S3_ENDPOINT>
  S3_ENDPOINT_URL_PREFIX: <DEMO_HIVE_S3_ENDPOINT_URL_PREFIX>
  S3_DATA_DIR: <DEMO_HIVE_S3_DATA_DIR>
```

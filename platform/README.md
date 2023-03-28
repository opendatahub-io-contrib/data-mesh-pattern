# helm base chart for rainforest platform openshift install

Supporting middleware infrastructure for the data mesh. 

Helm setup
```bash
helm repo add redhat-cop https://redhat-cop.github.io/helm-charts
helm repo add hashicorp https://helm.releases.hashicorp.com
helm dep up
```

Vault Route
```bash
export BASE_DOMAIN=$(oc get dns cluster -o jsonpath='{.spec.baseDomain}')
export VAULT_ROUTE=vault.apps.$BASE_DOMAIN
```

Gitlab Password
```bash
exort GITLAB_ROOT_PASSWORD=$(openssl rand -hex 8)
```

Install as cluster-admin
```bash
helm upgrade --install platform-base . \
  --set vault.server.route.host=$VAULT_ROUTE \
  --set vault.server.extraEnvironmentVars.VAULT_TLS_SERVER_NAME=$VAULT_ROUTE \
  --set gitlab.root_password=$GITLAB_ROOT_PASSWORD \
  --namespace data-mesh \
  --create-namespace \
  --timeout=10m \
  --debug \
  -f cluster-dev-values.yaml
```

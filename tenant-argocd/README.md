# tenant-argocd

See here for teaming models: 

- https://github.com/redhat-cop/helm-charts/blob/master/charts/gitops-operator/TEAM_DOCS.md

The rainforest repo is designed to be run using the `Platform ArgoCD, Namespaced ArgoCD per Team`. 

For the base deployment however it is convenient to use `Cluster ArgoCD per Team` which is a bit less complicated to setup.

## Cluster ArgoCD per Team

`FIXME - move to gitops` - Bootstrap privileged ArgoCD as follows:

Team:

```bash
export TEAM_NAME=rainforest
export GIT_SERVER=github.com
export SERVICE_ACCOUNT=vault
```

ArgoCD with ArgoCD Vault Plugin. Note if you want this Chart to deploy the Operator edit `operator: []`:

```bash
cat << EOF > /tmp/argocd-values.yaml
ignoreHelmHooks: true
operator: []
namespaces:
  - ${TEAM_NAME}-ci-cd
argocd_cr:
  statusBadgeEnabled: true
  repo:
    mountsatoken: true
    serviceaccount: ${SERVICE_ACCOUNT}
    volumes:
    - name: custom-tools
      emptyDir: {}
    initContainers:
    - name: download-tools
      image: registry.access.redhat.com/ubi8/ubi-minimal:latest
      command: [sh, -c]
      env:
        - name: AVP_VERSION
          value: "1.11.0"
      args:
        - >-
          curl -Lo /tmp/argocd-vault-plugin https://github.com/argoproj-labs/argocd-vault-plugin/releases/download/v\${AVP_VERSION}/argocd-vault-plugin_\${AVP_VERSION}_linux_amd64 && chmod +x /tmp/argocd-vault-plugin && mv /tmp/argocd-vault-plugin /custom-tools/
      volumeMounts:
      - mountPath: /custom-tools
        name: custom-tools
    volumeMounts:
    - mountPath: /usr/local/bin/argocd-vault-plugin
      name: custom-tools        
      subPath: argocd-vault-plugin    
  initialRepositories: |
    - name: rainforest
      url: https://github.com/opendatahub-io-contrib/data-mesh-pattern
  repositoryCredentials: |
    - url: https://${GIT_SERVER}
      type: git
      passwordSecret:
        key: password
        name: git-auth
      usernameSecret:
        key: username
        name: git-auth
  configManagementPlugins: |
    - name: argocd-vault-plugin
      generate:
        command: ["sh", "-c"]
        args: ["argocd-vault-plugin -s ${TEAM_NAME}-ci-cd:team-avp-credentials generate ./"]
    - name: argocd-vault-plugin-helm
      init:
        command: [sh, -c]
        args: ["helm dependency build"]
      generate:
        command: ["bash", "-c"]
        args: ['helm template "\$ARGOCD_APP_NAME" -n "\$ARGOCD_APP_NAMESPACE" -f <(echo "\$ARGOCD_ENV_HELM_VALUES") . | argocd-vault-plugin generate -s ${TEAM_NAME}-ci-cd:team-avp-credentials -']
    - name: argocd-vault-plugin-kustomize
      generate:
        command: ["sh", "-c"]
        args: ["kustomize build . | argocd-vault-plugin -s ${TEAM_NAME}-ci-cd:team-avp-credentials generate -"]
EOF
```

Install ArgoCD:

```bash
helm upgrade --install argocd \
  --namespace ${TEAM_NAME}-ci-cd \
  -f /tmp/argocd-values.yaml \
  --create-namespace \
  redhat-cop/gitops-operator
```

Create vault SA that runs the repo server:

```bash
oc -n ${TEAM_NAME}-ci-cd create sa ${SERVICE_ACCOUNT}
```

Need github secret to bootstrap (this is served from Vault later on):

```bash
GITHUB_USER=<github user>
GITHUB_TOKEN=<github token>

cat <<EOF | oc apply -f -
apiVersion: v1
data:
  password: "$(echo -n ${GITHUB_TOKEN} | base64)"
  username: "$(echo -n ${GITHUB_USER} | base64)"
kind: Secret
metadata:
  annotations:
    tekton.dev/git-0: https://${GIT_SERVER}
  name: git-auth
type: kubernetes.io/basic-auth
EOF
```

In OpenShift 4.11 no default token with ServiceAccount:

```bash
cat <<EOF | oc -n ${TEAM_NAME}-ci-cd apply -f -
apiVersion: v1
kind: Secret
metadata:
name: vault-token
annotations:
kubernetes.io/service-account.name: "vault"
type: kubernetes.io/service-account-token
EOF
```

Role Binding for the vault service account:

```bash
-- read secrets and bind to vault
oc adm policy add-cluster-role-to-user edit -z vault -n ${TEAM_NAME}-ci-cd
oc adm policy add-cluster-role-to-user system:auth-delegator -z vault -n ${TEAM_NAME}-ci-cd
```

Tenant setup:

Rainforest
```bash
kustomize build tenant-argocd/overlay/cluster-dev/rainforest | oc apply -n rainforest-ci-cd -f-
```

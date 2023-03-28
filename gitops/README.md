# Open Data Hub Manifests

Deploy our applications using ArgoCD.

### ArgoCD Deploy

`FIXME` - uses helm chart for now

### Hashi Vault Secrets

We use the [ArgoCD Vault plugin](https://argocd-vault-plugin.readthedocs.io) to integrate application secrets.

The encrypted secrets to load into vault are here:

```bash
ansible-vault encrypt gitops/secrets/vault-rainforest
ansible-vault decrypt gitops/secrets/vault-rainforest
```

Load them into vault.

### Applications

rainforest-ci-cd
```bash
oc -n rainforest-ci-cd apply -f gitops/argocd/rainforest-ci-cd-dev-app-of-apps.yaml
```

daintree-dev
```bash
oc -n rainforest-ci-cd apply -f gitops/argocd/daintree-dev-app-of-apps.yaml
```

### ArgoCD Webhook

ArgoCD controller has a cycle of 3min. To speed things up we can sync changes as soon as things hit this git repo. Add the webhook to this github repo to point to ArgoCD:

```bash
echo https://$(oc get route argocd-server --template='{{ .spec.host}}'/api/webhook)
```

# Identity and Access Management

We control via GitOps two things using this Helm Chart:

- User `RoleBinding` in OpenShift (view, edit)
- User SSO/Keycloak creation and specific application roles

The values files are structured per `cluster/namespace`. So a User may have different access to none, one or many cluster/namespaces.

## OpenShift RoleBindings

These are controlled via Standard AD/LDAP group membership and bound in via the standard RoleBindings in the gitops repository.

To first login to OpenShift you must be part of one of these groups (normally View only).

This Chart can then control Edit, View `RoleBindings` based on the specified User details contained in `values.yaml` files.

We do not override the default role bindings, so if you are in that AD group, you will have that level of OpenShift access regardless of what is in this git repo.

## Application Role

Fine grained RBAC for Applications is controlled via SSO/Keycloak. This Chart creates a `KeycloakUser` for each realm a User belongs to. There is one realm per project.

We specify some predefined Application Roles in the `templates\_helpers.tpl` file:

```bash
adminRole - Admin access role to applications
dsRole - Data Scientist / Data Analyst access role
viewRole - Restricted view on Superset
```

These may be subject to change.


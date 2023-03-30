{{- define "ldap_def" -}}
{{- $idp := (lookup "config.openshift.io/v1" "OAuth" "" "cluster").spec.identityProviders -}}
{{- range $idp -}}
{{- if hasKey . "ldap" }}
{{- $ldap := . -}}
{{- $ldap.ldap | toYaml -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "gitlab.ldap.port" -}}
{{- if $.Values.gitlab.ldap.port -}}
{{ $.Values.gitlab.ldap.port }}
{{- else -}}
{{- $ldap := include "ldap_def" . | fromYaml -}}
{{- $protocol := regexFind "^ldap[s]*" $ldap.url -}}
{{- if eq $protocol "ldap" }}
{{- print "389" -}}
{{- else -}}
{{- print "636" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "gitlab.ldap.base" -}}
{{- if $.Values.gitlab.ldap.base -}}
{{ $.Values.gitlab.ldap.base }}
{{- else -}}
{{- $ldap := include "ldap_def" . | fromYaml -}}
{{- $ldap_base_dn := regexReplaceAll "^ldap[s]*://" $ldap.url "${1}" | regexFind "/.*" | trimAll "/" | regexFind "^([^?]+)" }}
{{- printf "%s%s" "cn=accounts," $ldap_base_dn -}}
{{- end -}}
{{- end -}}

{{- define "gitlab.ldap.uri" -}}
{{- if $.Values.gitlab.ldap.uri -}}
{{ $.Values.gitlab.ldap.uri }}
{{- else -}}
{{- $ldap := include "ldap_def" . | fromYaml -}}
{{- regexReplaceAll "^ldap[s]*://" $ldap.url "${1}" | regexFind ".*/" | trimAll "/" | regexFind "^([^:]+)" }}
{{- end -}}
{{- end -}}

{{- define "gitlab.ldap.user_filter" -}}
{{ $.Values.gitlab.ldap.user_filter }}
{{- end -}}

{{- define "gitlab.ldap.encryption" -}}
{{- if $.Values.gitlab.ldap.encryption -}}
{{ $.Values.gitlab.ldap.encryption -}}
{{- else -}}
{{ $enc := include "gitlab.ldap.port" . }}
{{- if eq $enc "636" -}}
{{- print "simple_tls" -}}
{{- else -}}
{{- print "plain" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "gitlab.ldap.secret_name" -}}
{{ $ldap := include "ldap_def" . | fromYaml -}}
{{- print $ldap.bindPassword.name -}}
{{- end -}}

{{- define "gitlab.ldap.bind_password" -}}
{{- if $.Values.gitlab.ldap.password -}}
{{ $.Values.gitlab.ldap.password }}
{{- else -}}
{{- $secret := include "gitlab.ldap.secret_name" . -}}
{{- if (lookup "v1" "Secret" "openshift-config" $secret ) }}
{{- print (lookup "v1" "Secret" "openshift-config" $secret ).data.bindPassword | b64dec -}}
{{- end }}
{{- end }}
{{- end }}

{{- define "gitlab.ldap.bind_dn" -}}
{{- if $.Values.gitlab.ldap.bind_dn -}}
{{ $.Values.gitlab.ldap.bind_dn }}
{{- else -}}
{{- $ldap := include "ldap_def" . | fromYaml -}}
{{- print $ldap.bindDN -}}
{{- end -}}
{{- end -}}

{{- define "app_domain" -}}
{{- if (lookup "operator.openshift.io/v1" "IngressController" "openshift-ingress-operator" "default") -}}
{{- print (lookup "operator.openshift.io/v1" "IngressController" "openshift-ingress-operator" "default").status.domain -}}
{{- else -}}
{{- print "example.com" -}}
{{- end -}}
{{- end -}}

{{- define "gitlab.root_password" -}}
{{- print (randAlphaNum 10) -}}
{{- end -}}

{{- define "gitlab.postgres.user" -}}
{{- print (randAlphaNum 10) -}}
{{- end -}}

{{- define "gitlab.postgres.password" -}}
{{- print (randAlphaNum 10) -}}
{{- end -}}

{{- define "gitlab.postgres.admin_password" -}}
{{- print (randAlphaNum 10) -}}
{{- end -}}

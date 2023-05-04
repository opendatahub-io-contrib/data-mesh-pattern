{{/*
Expand the name of the chart.
*/}}
{{- define "iam.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "iam.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "iam.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "iam.labels" -}}
helm.sh/chart: {{ include "iam.chart" . }}
{{ include "iam.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "iam.selectorLabels" -}}
app.kubernetes.io/name: {{ include "iam.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Our Predefined Roles
*/}}

{{- define "adminRole" -}}
account:
- "manage-account"
- "manage-account-links"
- "view-profile"
superset:
- "Admin"
aflow:
- "Admin"
grafana:
- "Admin"
open-metadata:
- "Admin"
{{- end }}

{{- define "dsRole" -}}
account:
- "manage-account"
- "manage-account-links"
- "view-profile"
superset:
- "Alpha"
- "sql_lab"
aflow:
- "User"
grafana:
- "Editor"
{{- end }}

{{- define "dsAdminRole" -}}
account:
- "manage-account"
- "manage-account-links"
- "view-profile"
superset:
- "Admin"
aflow:
- "Admin"
grafana:
- "Editor"
{{- end }}

{{- define "viewRole" -}}
account:
- "manage-account"
- "manage-account-links"
- "view-profile"
superset:
- "Gamma"
{{- end }}

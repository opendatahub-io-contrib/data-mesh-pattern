{{/*
Expand the name of the chart.
*/}}
{{- define "google-spark-operator-cluster.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "google-spark-operator-cluster.fullname" -}}
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

{{- define "google-spark-operator.fullname" -}}
{{- printf "%s" "google-spark-operator" }}
{{- end }}

{{- define "spark-history.fullname" -}}
{{- printf "%s" "spark-history" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "google-spark-operator-cluster.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "google-spark-operator-cluster.labels" -}}
helm.sh/chart: {{ include "google-spark-operator-cluster.chart" . }}
{{ include "google-spark-operator-cluster.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
opendatahub.io/component: "false"
component.opendatahub.io/name: {{ include "google-spark-operator-cluster.name" . }}
{{- end }}

{{- define "spark-history.labels" -}}
helm.sh/chart: {{ include "google-spark-operator-cluster.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
opendatahub.io/component: "false"
component.opendatahub.io/name: {{ include "spark-history.fullname" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "google-spark-operator-cluster.selectorLabels" -}}
app.kubernetes.io/name: {{ include "google-spark-operator-cluster.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "google-spark-operator-cluster.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "google-spark-operator-cluster.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

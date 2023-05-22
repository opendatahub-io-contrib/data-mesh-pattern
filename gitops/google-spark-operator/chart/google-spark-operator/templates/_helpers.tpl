{{/*
Expand the name of the chart.
*/}}
{{- define "google-spark-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "google-spark-operator.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "google-spark.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s" "spark" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "google-spark-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "google-spark-operator.labels" -}}
helm.sh/chart: {{ include "google-spark-operator.chart" . }}
{{ include "google-spark-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
opendatahub.io/component: "false"
component.opendatahub.io/name: {{ include "google-spark-operator.name" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "google-spark-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "google-spark-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "google-spark-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "google-spark-operator.fullname" .) .Values.serviceAccount.operatorName }}
{{- else }}
{{- default "default" .Values.serviceAccount.operatorName }}
{{- end }}
{{- end }}

{{- define "google-spark.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "google-spark.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
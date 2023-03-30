{{/*
Expand the name of the chart.
*/}}
{{- define "airflowscheduler.name" -}}
{{- default "airflow-scheduler" .Values.nameOverrideScheduler | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "airflowweb.name" -}}
{{- default "airflow-web" .Values.nameOverrideWeb | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "airflowworker.name" -}}
{{- default "airflow-worker" .Values.nameOverrideWorker | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "airflowpostgresql.name" -}}
{{- default "airflow-postgresql" .Values.nameOverridePostgresql | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "airflowredis.name" -}}
{{- default "airflow-redis" .Values.nameOverrideRedis | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "airflowscheduler.fullname" -}}
{{- if .Values.fullnameOverrideScheduler }}
{{- .Values.fullnameOverrideScheduler | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "airflow-scheduler" .Values.nameOverrideScheduler }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "airflowweb.fullname" -}}
{{- if .Values.fullnameOverrideWeb }}
{{- .Values.fullnameOverrideWeb | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "airflow-web" .Values.nameOverrideWeb }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "airflowworker.fullname" -}}
{{- if .Values.fullnameOverrideWorker }}
{{- .Values.fullnameOverrideWorker | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "airflow-worker" .Values.nameOverrideWorker }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "airflowpostgresql.fullname" -}}
{{- if .Values.fullnameOverridePostgresql }}
{{- .Values.fullnameOverridePostgresql | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "airflow-postgresql" .Values.nameOverridePostgresql }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "airflowredis.fullname" -}}
{{- if .Values.fullnameOverrideRedis }}
{{- .Values.fullnameOverrideRedis | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "airflow-redis" .Values.nameOverrideRedis }}
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
{{- define "airflow.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "airflowscheduler.labels" -}}
helm.sh/chart: {{ include "airflow.chart" . }}
{{ include "airflowscheduler.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "airflowweb.labels" -}}
helm.sh/chart: {{ include "airflow.chart" . }}
{{ include "airflowweb.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "airflowworker.labels" -}}
helm.sh/chart: {{ include "airflow.chart" . }}
{{ include "airflowworker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "airflowpostgresql.labels" -}}
helm.sh/chart: {{ include "airflow.chart" . }}
{{ include "airflowpostgresql.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "airflowredis.labels" -}}
helm.sh/chart: {{ include "airflow.chart" . }}
{{ include "airflowredis.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "airflowscheduler.selectorLabels" -}}
app.kubernetes.io/name: {{ include "airflowscheduler.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "airflowweb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "airflowweb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "airflowworker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "airflowworker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "airflowpostgresql.selectorLabels" -}}
app.kubernetes.io/name: {{ include "airflowpostgresql.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "airflowredis.selectorLabels" -}}
app.kubernetes.io/name: {{ include "airflowredis.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "airflow.serviceAccountName" -}}
{{- default "airflow-core" .Values.serviceAccount.name }}
{{- end }}

{{- define "airflowredis.serviceAccountName" -}}
{{- default "airflow-redis" .Values.serviceAccount.nameRedis }}
{{- end }}

{{- define "airflowproxy.serviceAccountName" -}}
{{- default "airflow-proxy" .Values.serviceAccount.nameProxy }}
{{- end }}
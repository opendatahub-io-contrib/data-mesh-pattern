{{/*
Expand the name of the chart.
*/}}
{{- define "trino.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "hive-metastore.name" -}}
{{- default "hive-metastore" .Values.nameOverrideHive | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "hivedb.name" -}}
{{- default "hivedb" .Values.nameOverrideDb | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "trinoworker.name" -}}
{{- default "trino-worker" .Values.nameOverrideWorker | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "trino.fullname" -}}
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

{{- define "hive-metastore.fullname" -}}
{{- if .Values.fullnameOverrideHive }}
{{- .Values.fullnameOverrideHive | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "hive-metastore" .Values.nameOverrideHive }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "hivedb.fullname" -}}
{{- if .Values.fullnameOverrideDb }}
{{- .Values.fullnameOverrideDb | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "hivedb" .Values.nameOverrideDb }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "trinoworker.fullname" -}}
{{- if .Values.fullnameOverrideWorker }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "trino-worker" .Values.nameOverrideWorker }}
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
{{- define "trino.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "trino.labels" -}}
helm.sh/chart: {{ include "trino.chart" . }}
{{ include "trino.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "hive-metastore.labels" -}}
helm.sh/chart: {{ include "trino.chart" . }}
{{ include "hive-metastore.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "hivedb.labels" -}}
helm.sh/chart: {{ include "trino.chart" . }}
{{ include "hivedb.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "trinoworker.labels" -}}
helm.sh/chart: {{ include "trino.chart" . }}
{{ include "trinoworker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "trino.selectorLabels" -}}
app.kubernetes.io/name: {{ include "trino.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "hive-metastore.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hive-metastore.name" . }}
{{- end }}

{{- define "hivedb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hivedb.name" . }}
{{- end }}

{{- define "trinoworker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "trinoworker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "trino.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "trino.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "hive-metastore.serviceAccountName" -}}
{{- if .Values.serviceAccountHive.create }}
{{- default (include "trino.fullname" .) .Values.serviceAccountHive.name }}
{{- else }}
{{- default "default" .Values.serviceAccountHive.name }}
{{- end }}
{{- end }}

{{- define "hivedb.serviceAccountName" -}}
{{- if .Values.serviceAccountDb.create }}
{{- default (include "trino.fullname" .) .Values.serviceAccountDb.name }}
{{- else }}
{{- default "default" .Values.serviceAccountDb.name }}
{{- end }}
{{- end }}

{{- define "trinoworker.serviceAccountName" -}}
{{- if .Values.serviceAccountWorker.create }}
{{- default (include "trino.fullname" .) .Values.serviceAccountWorker.name }}
{{- else }}
{{- default "default" .Values.serviceAccountWorker.name }}
{{- end }}
{{- end }}

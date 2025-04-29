{{/*
Expand the name of the chart.
*/}}
{{- define "dql-marketplace.name" -}}
{{ .Chart.Name }}
{{- end }}

{{/*
Create a name using INSTANCE_NAME if provided.
*/}}
{{- define "dql-marketplace.fullname" -}}
{{- if .Values.INSTANCE_NAME }}
{{ .Release.Name }}
{{- else }}
{{ .Release.Name }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dql-marketplace.labels" -}}
app.kubernetes.io/name: {{ include "dql-marketplace.name" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels (for StatefulSet or Service selectors)
*/}}
{{- define "dql-marketplace.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dql-marketplace.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

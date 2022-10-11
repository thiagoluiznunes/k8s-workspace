{{/* get labels */}}
{{- define "demo.labels" -}}
{{- include "demo.localLabels" . }}
{{- range $label, $value := .Values.global.labels }}
{{ $label }}: {{ $value | quote }}
{{- end }}
{{- end -}}

{{- define "demo.localLabels" -}}
chart: {{ .Chart.Name}}-{{ .Chart.Version }}
template: {{ regexReplaceAll "\\W+" .Template.Name "_"}}
{{- end -}}
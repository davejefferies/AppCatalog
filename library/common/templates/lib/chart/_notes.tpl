{{- define "common.lib.chart.notes" -}}

  {{- include "common.lib.chart.header" . -}}

  {{- include "common.lib.chart.custom" . -}}

  {{- include "common.lib.chart.footer" . -}}

{{- end -}}

{{- define "common.lib.chart.header" -}}
  {{- tpl $.Values.notes.header $ | nindent 0 }}
{{- end -}}

{{- define "common.lib.chart.custom" -}}
  {{- tpl $.Values.notes.custom $ | nindent 0 }}
{{- end -}}

{{- define "common.lib.chart.footer" -}}
  {{- tpl $.Values.notes.footer $ | nindent 0 }}
{{- end -}}

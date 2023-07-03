{{/* Annotations that are added to podSpec */}}
{{/* Call this template:
{{ include "common.lib.metadata.podAnnotations" $ }}
*/}}
{{- define "common.lib.metadata.podAnnotations" -}}
rollme: {{ randAlphaNum 5 | quote }}
{{- end -}}

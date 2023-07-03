{{/* Secret Spawwner */}}
{{/* Call this template:
{{ include "common.spawner.secret" $ -}}
*/}}

{{- define "common.spawner.secret" -}}

  {{- range $name, $secret := .Values.secret -}}

    {{- if $secret.enabled -}}

      {{/* Create a copy of the secret */}}
      {{- $objectData := (mustDeepCopy $secret) -}}

      {{- $objectName := (printf "%s-%s" (include "common.lib.chart.names.fullname" $) $name) -}}
      {{/* Perform validations */}}
      {{- include "common.lib.chart.names.validation" (dict "name" $objectName) -}}
      {{- include "common.lib.secret.validation" (dict "objectData" $objectData) -}}
      {{- include "common.lib.metadata.validation" (dict "objectData" $objectData "caller" "Secret") -}}

      {{/* Set the name of the secret */}}
      {{- $_ := set $objectData "name" $objectName -}}
      {{- $_ := set $objectData "shortName" $name -}}

      {{/* Call class to create the object */}}
      {{- include "common.class.secret" (dict "rootCtx" $ "objectData" $objectData) -}}

    {{- end -}}

  {{- end -}}

{{- end -}}

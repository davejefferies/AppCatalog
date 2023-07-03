{{/* Configmap Spawwner */}}
{{/* Call this template:
{{ include "common.spawner.configmap" $ -}}
*/}}

{{- define "common.spawner.configmap" -}}

  {{- range $name, $configmap := .Values.configmap -}}

    {{- if $configmap.enabled -}}

      {{/* Create a copy of the configmap */}}
      {{- $objectData := (mustDeepCopy $configmap) -}}

      {{- $objectName := (printf "%s-%s" (include "common.lib.chart.names.fullname" $) $name) -}}
      {{/* Perform validations */}}
      {{- include "common.lib.chart.names.validation" (dict "name" $objectName) -}}
      {{- include "common.lib.configmap.validation" (dict "objectData" $objectData) -}}
      {{- include "common.lib.metadata.validation" (dict "objectData" $objectData "caller" "ConfigMap") -}}

      {{/* Set the name of the configmap */}}
      {{- $_ := set $objectData "name" $objectName -}}
      {{- $_ := set $objectData "shortName" $name -}}

      {{/* Call class to create the object */}}
      {{- include "common.class.configmap" (dict "rootCtx" $ "objectData" $objectData) -}}

    {{- end -}}

  {{- end -}}

{{- end -}}

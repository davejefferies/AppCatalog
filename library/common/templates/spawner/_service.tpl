{{/* Service Spawner */}}
{{/* Call this template:
{{ include "common.spawner.service" $ -}}
*/}}

{{- define "common.spawner.service" -}}

  {{/* Primary validation for enabled service. */}}
  {{- include "common.lib.service.primaryValidation" $ -}}

  {{- range $name, $service := .Values.service -}}

    {{- if $service.enabled -}}

      {{/* Create a copy of the configmap */}}
      {{- $objectData := (mustDeepCopy $service) -}}

      {{- $objectName := include "common.lib.chart.names.fullname" $ -}}
      {{- if not $objectData.primary -}}
        {{- $objectName = (printf "%s-%s" (include "common.lib.chart.names.fullname" $) $name) -}}
      {{- end -}}

      {{/* Perform validations */}}
      {{- include "common.lib.chart.names.validation" (dict "name" $objectName) -}}
      {{- include "common.lib.metadata.validation" (dict "objectData" $objectData "caller" "Service") -}}
      {{- include "common.lib.service.validation" (dict "rootCtx" $ "objectData" $objectData) -}}

      {{/* Set the name of the service account */}}
      {{- $_ := set $objectData "name" $objectName -}}
      {{- $_ := set $objectData "shortName" $name -}}

      {{/* Call class to create the object */}}
      {{- include "common.class.service" (dict "rootCtx" $ "objectData" $objectData) -}}

    {{- end -}}

  {{- end -}}

{{- end -}}

{{/* Service Account Spawner */}}
{{/* Call this template:
{{ include "common.spawner.serviceAccount" $ -}}
*/}}

{{- define "common.spawner.serviceAccount" -}}

  {{/* Primary validation for enabled service accounts. */}}
  {{- include "common.lib.serviceAccount.primaryValidation" $ -}}

  {{- range $name, $serviceAccount := .Values.serviceAccount -}}

    {{- if $serviceAccount.enabled -}}

      {{/* Create a copy of the configmap */}}
      {{- $objectData := (mustDeepCopy $serviceAccount) -}}

      {{- $objectName := include "common.lib.chart.names.fullname" $ -}}
      {{- if not $objectData.primary -}}
        {{- $objectName = (printf "%s-%s" (include "common.lib.chart.names.fullname" $) $name) -}}
      {{- end -}}

      {{/* Perform validations */}}
      {{- include "common.lib.chart.names.validation" (dict "name" $objectName) -}}
      {{- include "common.lib.metadata.validation" (dict "objectData" $objectData "caller" "Service Account") -}}

      {{/* Set the name of the service account */}}
      {{- $_ := set $objectData "name" $objectName -}}
      {{- $_ := set $objectData "shortName" $name -}}

      {{/* Call class to create the object */}}
      {{- include "common.class.serviceAccount" (dict "rootCtx" $ "objectData" $objectData) -}}

    {{- end -}}

  {{- end -}}

{{- end -}}

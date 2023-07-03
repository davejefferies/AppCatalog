{{/* Image Pull Secrets Spawner */}}
{{/* Call this template:
{{ include "common.spawner.imagePullSecret" $ -}}
*/}}

{{- define "common.spawner.imagePullSecret" -}}

  {{- range $name, $imgPullSecret := .Values.imagePullSecret -}}

    {{- if $imgPullSecret.enabled -}}

      {{/* Create a copy of the configmap */}}
      {{- $objectData := (mustDeepCopy $imgPullSecret) -}}

      {{- $objectName := (printf "%s-%s" (include "common.lib.chart.names.fullname" $) $name) -}}

      {{/* Perform validations */}}
      {{- include "common.lib.chart.names.validation" (dict "name" $objectName) -}}
      {{- include "common.lib.imagePullSecret.validation" (dict "objectData" $objectData) -}}
      {{- include "common.lib.metadata.validation" (dict "objectData" $objectData "caller" "Image Pull Secret") -}}
      {{- $data := include "common.lib.imagePullSecret.createData" (dict "rootCtx" $ "objectData" $objectData) -}}

      {{/* Update the data */}}
      {{- $_ := set $objectData "data" $data -}}

      {{/* Set the type to Image Pull Secret */}}
      {{- $_ := set $objectData "type" "imagePullSecret" -}}

      {{/* Set the name of the image pull secret */}}
      {{- $_ := set $objectData "name" $objectName -}}
      {{- $_ := set $objectData "shortName" $name -}}

      {{/* Call class to create the object */}}
      {{- include "common.class.secret" (dict "rootCtx" $ "objectData" $objectData) -}}

    {{- end -}}

  {{- end -}}

{{- end -}}

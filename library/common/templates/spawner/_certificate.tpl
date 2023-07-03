{{/* Certificate Spawwner */}}
{{/* Call this template:
{{ include "common.spawner.certificate" $ -}}
*/}}

{{- define "common.spawner.certificate" -}}

  {{- range $name, $certificate := .Values.scaleCertificate -}}

    {{- if $certificate.enabled -}}

      {{/* Create a copy of the certificate */}}
      {{- $objectData := (mustDeepCopy $certificate) -}}

      {{- $objectName := (printf "%s-%s" (include "common.lib.chart.names.fullname" $) $name) -}}
      {{/* Perform validations */}}
      {{- include "common.lib.chart.names.validation" (dict "name" $objectName) -}}
      {{- include "common.lib.certificate.validation" (dict "objectData" $objectData) -}}
      {{- include "common.lib.metadata.validation" (dict "objectData" $objectData "caller" "Certificate") -}}

      {{/* Prepare data */}}
      {{- $data := fromJson (include "common.lib.certificate.getData" (dict "rootCtx" $ "objectData" $objectData)) -}}
      {{- $_ := set $objectData "data" $data -}}

      {{/* Set the type to certificate */}}
      {{- $_ := set $objectData "type" "certificate" -}}

      {{/* Set the name of the certificate */}}
      {{- $_ := set $objectData "name" $objectName -}}
      {{- $_ := set $objectData "shortName" $name -}}

      {{/* Call class to create the object */}}
      {{- include "common.class.secret" (dict "rootCtx" $ "objectData" $objectData) -}}

    {{- end -}}

  {{- end -}}

{{- end -}}

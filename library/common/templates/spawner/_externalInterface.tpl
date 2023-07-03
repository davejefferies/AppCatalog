{{/* External Interface Spawwner */}}
{{/* Call this template:
{{ include "common.spawner.externalInterface" $ -}}
*/}}

{{- define "common.spawner.externalInterface" -}}

  {{- range $iface := .Values.scaleExternalInterface -}}
    {{- include "common.lib.externalInterface.validation" (dict "objectData" $iface) -}}
  {{- end -}}

  {{/* Now we have validated interfaces, render the objects */}}

  {{- range $index, $interface := .Values.ixExternalInterfacesConfiguration -}}

    {{- $objectData := dict -}}
    {{/* Create a copy of the interface and put it in objectData.config */}}
    {{- $_ := set $objectData "config" (mustDeepCopy $interface) -}}

    {{- $objectName := (printf "ix-%s-%v" $.Release.Name $index) -}}
    {{/* Perform validations */}}
    {{- include "common.lib.chart.names.validation" (dict "name" $objectName) -}}

    {{/* Set the name of the object to objectData.name */}}
    {{- $_ := set $objectData "name" $objectName -}}

    {{/* Call class to create the object */}}
    {{- include "common.class.networkAttachmentDefinition" (dict "rootCtx" $ "objectData" $objectData) -}}

  {{- end -}}

{{- end -}}

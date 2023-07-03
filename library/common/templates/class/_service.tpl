{{/* Service Class */}}
{{/* Call this template:
{{ include "common.class.service" (dict "rootCtx" $ "objectData" $objectData) }}

rootCtx: The root context of the chart.
objectData: The service data, that will be used to render the Service object.
*/}}

{{- define "common.class.service" -}}

  {{- $rootCtx := .rootCtx -}}
  {{- $objectData := .objectData -}}

  {{- $svcType := $objectData.type | default $rootCtx.Values.fallbackDefaults.serviceType -}}

  {{/* Init variables */}}
  {{- $hasHostPort := false -}}
  {{- $hostNetwork := false -}}
  {{- $podValues := dict -}}

  {{/* Get Pod Values based on the selector (or the absence of it) */}}
  {{- $podValues = fromJson (include "common.lib.helpers.getSelectedPodValues" (dict "rootCtx" $rootCtx "objectData" $objectData "caller" "Service")) -}}

  {{- if $podValues -}}
    {{/* Get Pod hostNetwork configuration */}}
    {{- $hostNetwork = include "common.lib.pod.hostNetwork" (dict "rootCtx" $rootCtx "objectData" $podValues) -}}

    {{/* When hostNetwork is set on the pod, force ClusterIP, so services wont try to bind the same ports on the host */}}
    {{- if or (and (kindIs "bool" $hostNetwork) $hostNetwork) (and (kindIs "string" $hostNetwork) (eq $hostNetwork "true")) -}}
      {{- $svcType = "ClusterIP" -}}
    {{- end -}}
  {{- end -}}

  {{- range $portName, $port := $objectData.ports -}}
    {{- if $port.enabled -}}
      {{- if and (hasKey $port "hostPort") $port.hostPort -}}
        {{- $hasHostPort = true -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{/* When hostPort is defined, force ClusterIP aswell */}}
  {{- if $hasHostPort -}}
    {{- $svcType = "ClusterIP" -}}
  {{- end -}}
  {{- $_ := set $objectData "type" $svcType }}

---
apiVersion: v1
kind: Service
metadata:
  name: {{ $objectData.name }}
  {{- $labels := (mustMerge ($objectData.labels | default dict) (include "common.lib.metadata.allLabels" $rootCtx | fromYaml)
                            (include "common.lib.metadata.selectorLabels" (dict "rootCtx" $rootCtx "objectType" "service" "objectName" $objectData.shortName) | fromYaml)) -}}
  {{- with (include "common.lib.metadata.render" (dict "rootCtx" $rootCtx "labels" $labels) | trim) }}
  labels:
    {{- . | nindent 4 }}
  {{- end -}}
  {{- $annotations := (mustMerge ($objectData.annotations | default dict) (include "common.lib.metadata.allAnnotations" $rootCtx | fromYaml)) -}}
  {{- with (include "common.lib.metadata.render" (dict "rootCtx" $rootCtx "annotations" $annotations) | trim) }}
  annotations:
    {{- . | nindent 4 }}
  {{- end }}
spec:
  {{- if eq $objectData.type "ClusterIP" -}}
    {{- include "common.lib.service.spec.clusterIP" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 2 -}}
  {{- else if eq $objectData.type "NodePort" -}}
    {{- include "common.lib.service.spec.nodePort" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 2 -}}
  {{- end -}}
  {{- with (include "common.lib.service.ports" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim) }}
  ports:
    {{- . | nindent 4 }}
  {{- end }}
  selector:
    {{- include "common.lib.metadata.selectorLabels" (dict "rootCtx" $rootCtx "objectType" "pod" "objectName" $podValues.shortName) | trim | nindent 4 -}}
{{- end -}}

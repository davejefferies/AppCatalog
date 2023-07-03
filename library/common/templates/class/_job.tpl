{{/* Job Class */}}
{{/* Call this template:
{{ include "common.class.job" (dict "rootCtx" $ "objectData" $objectData) }}

rootCtx: The root context of the chart.
objectData: The object data to be used to render the Job.
*/}}

{{- define "common.class.job" -}}

  {{- $rootCtx := .rootCtx -}}
  {{- $objectData := .objectData -}}
  {{- include "common.lib.workload.jobValidation" (dict "objectData" $objectData) }}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ $objectData.name }}
  {{- $labels := (mustMerge ($objectData.labels | default dict) (include "common.lib.metadata.allLabels" $rootCtx | fromYaml)) -}}
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
  {{- include "common.lib.workload.jobSpec" (dict "rootCtx" $rootCtx "objectData" $objectData) | nindent 2 }}
  template:
    metadata:
        {{- $labels := (mustMerge ($objectData.podSpec.labels | default dict)
                                  (include "common.lib.metadata.allLabels" $rootCtx | fromYaml)
                                  (include "common.lib.metadata.podLabels" $rootCtx | fromYaml)
                                  (include "common.lib.metadata.selectorLabels" (dict "rootCtx" $rootCtx "objectType" "pod" "objectName" $objectData.shortName) | fromYaml)) -}}
        {{- with (include "common.lib.metadata.render" (dict "rootCtx" $rootCtx "labels" $labels) | trim) }}
      labels:
        {{- . | nindent 8 }}
        {{- end -}}
        {{- $annotations := (mustMerge ($objectData.podSpec.annotations | default dict)
                                        (include "common.lib.metadata.allAnnotations" $rootCtx | fromYaml)
                                        (include "common.lib.metadata.externalInterfacePodAnnotations" (dict "rootCtx" $rootCtx "objectData" $objectData) | fromYaml)
                                        (include "common.lib.metadata.podAnnotations" $rootCtx | fromYaml)) -}}
        {{- with (include "common.lib.metadata.render" (dict "rootCtx" $rootCtx "annotations" $annotations) | trim) }}
      annotations:
        {{- . | nindent 8 }}
        {{- end }}
    spec:
      {{- include "common.lib.workload.pod" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 6 }}
{{- end -}}
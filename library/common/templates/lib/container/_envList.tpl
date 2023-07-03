{{/* Returns Env List */}}
{{/* Call this template:
{{ include "common.lib.container.envList" (dict "rootCtx" $ "objectData" $objectData) }}
rootCtx: The root context of the chart.
objectData: The object data to be used to render the container.
*/}}
{{- define "common.lib.container.envList" -}}
  {{- $rootCtx := .rootCtx -}}
  {{- $objectData := .objectData -}}

  {{- range $env := $objectData.envList -}}
    {{- if not $env.name -}}
      {{- fail "Container - Expected non-empty <envList.name>" -}}
    {{- end -}} {{/* Empty value is valid */}}
    {{- include "common.helper.container.envDupeCheck" (dict "rootCtx" $rootCtx "objectData" $objectData "source" "envList" "key" $env.name) }}
- name: {{ $env.name | quote }}
  value: {{ tpl (toString $env.value) $rootCtx | quote }}
  {{- end -}}
{{- end -}}
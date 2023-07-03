{{/* Loads all spawners */}}
{{- define "common.loader.apply" -}}

  {{/* Make sure there are not any YAML errors */}}
  {{- include "common.values.validate" .Values -}}

  {{/* Render ConfigMap(s) */}}
  {{- include "common.spawner.configmap" . | nindent 0 -}}

  {{/* Render Certificate(s) */}}
  {{- include "common.spawner.certificate" . | nindent 0 -}}

  {{/* Render Secret(s) */}}
  {{- include "common.spawner.secret" . | nindent 0 -}}

  {{/* Render Image Pull Secrets(s) */}}
  {{- include "common.spawner.imagePullSecret" . | nindent 0 -}}

  {{/* Render Service Accounts(s) */}}
  {{- include "common.spawner.serviceAccount" . | nindent 0 -}}

  {{/* Render RBAC(s) */}}
  {{- include "common.spawner.rbac" . | nindent 0 -}}

  {{/* Render External Interface(s) */}}
  {{- include "common.spawner.externalInterface" . | nindent 0 -}}

  {{/* Render Workload(s) */}}
  {{- include "common.spawner.workload" . | nindent 0 -}}

  {{/* Render Services(s) */}}
  {{- include "common.spawner.service" . | nindent 0 -}}

{{- end -}}

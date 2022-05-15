{{ define "common.ingress"  }}
{{- if .Values.ingress.enabled -}}
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: {{ include "common.fullname" . }}
spec:
  entryPoints:
    - web
  routes:
  - match: Prefix(.Values.service.path | quote)
    kind: Rule
    services:
    - name: {{ include "common.fullname" . }}
      namespace: {{ .Release.Namespace }}
      port: {{ .Values.service.port }}
{{- end }}
{{- end }}

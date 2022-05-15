{{ define "common.kedaNewrelic" }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "common.fullname" . }}-scaler-nr-secret
  namespace: {{ .Release.Namespace }}
type: Opaque
data:
  apiKey: {{ .Values.global.apiKey }} # base64 encoding of the new relic api key NRAK-UCPOC2VA9MMTJA4NZ939JVJ9FAW
---
apiVersion: keda.sh/v1alpha1
kind: TriggerAuthentication
metadata:
  name: {{ include "common.fullname" . }}-scaler-nr-auth
  namespace: {{ .Release.Namespace }}
spec:
  secretTargetRef:
  - parameter: queryKey
    name: {{ include "common.fullname" . }}-scaler-nr-secret
    key: apiKey
---
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: {{ include "common.fullname" . }}-scaler-nr
  namespace: {{ .Release.Namespace }}
spec:
  maxReplicaCount: {{ .Values.scalerNewrelic.maxReplicaCount }} 
  minReplicaCount: {{ .Values.scalerNewrelic.minReplicaCount }}
  scaleTargetRef:
    name: {{ include "common.fullname" . }}
  triggers:
    - type: new-relic
      metadata:
        account: {{ .Values.global.account | quote }}
        region: "US"
        nrql: {{ .Values.scalerNewrelic.nrql }}
        noDataError: {{ .Values.scalerNewrelic.noDataError | quote }}
        threshold: {{ .Values.scalerNewrelic.threshold | quote }}
      authenticationRef:
        name: {{ include "common.fullname" . }}-scaler-nr-auth
{{- end }}

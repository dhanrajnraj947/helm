{{ define "common.kedaCPU" }}
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: {{ include "common.fullname" . }}-scaler-cpu
  namespace: {{ .Release.Namespace }}
spec:
  maxReplicaCount: {{ .Values.scalerCpu.maxReplicaCount }}
  minReplicaCount: {{ .Values.scalerCpu.minReplicaCount }}
  cooldownPeriod: {{ .Values.scalerCpu.cooldownPeriod }}
  scaleTargetRef:
    name: {{ include "common.fullname" . }}
  advanced:                                          # Optional. Section to specify advanced options
    horizontalPodAutoscalerConfig:                   # Optional. Section to specify HPA related options
      behavior:                                      # Optional. Use to modify HPA's scaling behavior
        scaleDown:
          stabilizationWindowSeconds: {{ .Values.scalerCpu.stabilizationWindowSeconds }}
  triggers:
  - type: cpu
    metadata:
      type: Utilization
      value: {{ .Values.scalerCpu.value  | quote }}
{{- end }}

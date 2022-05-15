{{ define "common.kedaKafka" }}
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: {{ include "common.fullname" . }}-scaler-kafka
  namespace: {{ .Release.Namespace }}
spec:
  scaleTargetRef:
    name: {{ include "common.fullname" . }}
  pollingInterval: {{ .Values.scalerKafka.pollingInterval }}
  cooldownPeriod: {{ .Values.scalerKafka.cooldownPeriod }}
  minReplicaCount: {{ .Values.scalerKafka.minReplicaCount }}
  maxReplicaCount: {{ .Values.scalerKafka.maxReplicaCount }}
  advanced:
    horizontalPodAutoscalerConfig:
      behavior:
        scaleDown:
          stabilizationWindowSeconds: {{ .Values.scalerKafka.stabilizationWindowSeconds }}
  triggers:
  - type: kafka
    metadata:
      bootstrapServers: {{ .Values.global.bootstrapServers }}
      consumerGroup: {{ .Values.scalerKafka.consumerGroup }} # Make sure that this consumer group name is the same one as the one that is consuming topics
      topic: {{ .Values.global.topic }}
      # Optional
      lagThreshold: {{ .Values.scalerKafka.lagThreshold | quote }}  
      offsetResetPolicy: {{ .Values.global.offsetResetPolicy }}
{{- end }}

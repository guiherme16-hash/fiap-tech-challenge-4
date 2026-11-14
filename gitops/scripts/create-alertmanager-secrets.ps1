<#
.SYNOPSIS
  Cria o Secret com a routing key do PagerDuty e a URL do webhook do Discord,
  usados pelo Alertmanager. Os segredos NUNCA ficam no Git.

.EXEMPLO
  ./create-alertmanager-secrets.ps1 -PagerDutyRoutingKey "xxxx" -DiscordWebhookUrl "https://discord.com/api/webhooks/..."
#>
param(
  [string]$Namespace = "monitoring",
  [Parameter(Mandatory = $true)][string]$PagerDutyRoutingKey,
  [Parameter(Mandatory = $true)][string]$DiscordWebhookUrl
)

$ErrorActionPreference = "Stop"

kubectl create namespace $Namespace --dry-run=client -o yaml | kubectl apply -f -

Write-Host "Criando/atualizando Secret alertmanager-secrets em $Namespace..."
kubectl create secret generic alertmanager-secrets -n $Namespace `
  --from-literal=pagerduty-routing-key="$PagerDutyRoutingKey" `
  --from-literal=discord-webhook-url="$DiscordWebhookUrl" `
  --dry-run=client -o yaml | kubectl apply -f -

Write-Host "Pronto. Secret alertmanager-secrets criado. Reinicie o Alertmanager se ja estiver rodando:"
Write-Host "  kubectl rollout restart statefulset/alertmanager-kps-kube-prometheus-stack-alertmanager -n $Namespace"

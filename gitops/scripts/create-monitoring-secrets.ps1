<#
.SYNOPSIS
  Cria o Secret de admin do Grafana no cluster (namespace monitoring).
  A senha NUNCA fica no Git.

.EXEMPLO
  ./create-monitoring-secrets.ps1 -AdminPassword "uma-senha-forte"
#>
param(
  [string]$Namespace = "monitoring",
  [string]$AdminUser = "admin",
  [Parameter(Mandatory = $true)][string]$AdminPassword
)

$ErrorActionPreference = "Stop"

function Ensure-Namespace($ns) {
  kubectl create namespace $ns --dry-run=client -o yaml | kubectl apply -f -
}

Ensure-Namespace $Namespace

Write-Host "Criando/atualizando Secret grafana-admin em $Namespace..."
kubectl create secret generic grafana-admin -n $Namespace `
  --from-literal=admin-user="$AdminUser" `
  --from-literal=admin-password="$AdminPassword" `
  --dry-run=client -o yaml | kubectl apply -f -

Write-Host "Pronto. Secret grafana-admin criado no namespace $Namespace."

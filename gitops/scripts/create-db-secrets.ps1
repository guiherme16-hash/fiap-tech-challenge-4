<#
.SYNOPSIS
  Cria os Secrets de banco no cluster a partir do AWS Secrets Manager.
  As credenciais NUNCA ficam no Git — vêm do Secrets Manager (populado pelo Terraform).

.EXEMPLO
  ./create-db-secrets.ps1 -MasterKey "uma-chave-admin-forte"
#>
param(
  [string]$Prefix = "togglemaster-prod",
  [string]$Region = "us-east-1",
  [string]$Profile = "fiap",
  [Parameter(Mandatory = $true)][string]$MasterKey
)

$ErrorActionPreference = "Stop"

function Get-DbUrl($key) {
  $secret = aws secretsmanager get-secret-value `
    --secret-id "$Prefix/rds/$key" `
    --region $Region `
    --profile $Profile `
    --query SecretString --output text
  return ($secret | ConvertFrom-Json).url
}

function Ensure-Namespace($ns) {
  kubectl create namespace $ns --dry-run=client -o yaml | kubectl apply -f -
}

Ensure-Namespace "tc2-auth"
Ensure-Namespace "tc2-flags"
Ensure-Namespace "tc2-targeting"

Write-Host "Lendo credenciais do Secrets Manager..."
$authUrl = Get-DbUrl "auth"
$flagsUrl = Get-DbUrl "flags"
$targUrl = Get-DbUrl "targeting"

Write-Host "Criando/atualizando Secrets no cluster..."
kubectl create secret generic tc2-auth-secret -n tc2-auth `
  --from-literal=DATABASE_URL="$authUrl" `
  --from-literal=MASTER_KEY="$MasterKey" `
  --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic tc2-flags-secret -n tc2-flags `
  --from-literal=DATABASE_URL="$flagsUrl" `
  --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic tc2-targeting-secret -n tc2-targeting `
  --from-literal=DATABASE_URL="$targUrl" `
  --dry-run=client -o yaml | kubectl apply -f -

Write-Host "Pronto. Secrets tc2-auth-secret, tc2-flags-secret e tc2-targeting-secret criados."

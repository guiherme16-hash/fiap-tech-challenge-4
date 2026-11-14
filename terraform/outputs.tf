# ------------------------------------------------------------------------------
# Networking
# ------------------------------------------------------------------------------
output "vpc_id" {
  description = "ID da VPC."
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas."
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas."
  value       = module.networking.private_subnet_ids
}

# ------------------------------------------------------------------------------
# EKS
# ------------------------------------------------------------------------------
output "cluster_name" {
  description = "Nome do cluster EKS."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint da API do cluster EKS."
  value       = module.eks.cluster_endpoint
}

output "cluster_oidc_provider_arn" {
  description = "ARN do OIDC provider do cluster (para IRSA)."
  value       = module.eks.oidc_provider_arn
}

output "configure_kubectl" {
  description = "Comando para configurar o kubeconfig local."
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

# ------------------------------------------------------------------------------
# ECR
# ------------------------------------------------------------------------------
output "ecr_repository_urls" {
  description = "URLs dos repositórios ECR por microsserviço."
  value       = module.ecr.repository_urls
}

# ------------------------------------------------------------------------------
# RDS
# ------------------------------------------------------------------------------
output "rds_endpoints" {
  description = "Endpoints das instâncias RDS por banco."
  value       = module.rds.instance_endpoints
}

output "rds_secret_arns" {
  description = "ARNs dos secrets (Secrets Manager) com as credenciais RDS."
  value       = module.rds.secret_arns
}

# ------------------------------------------------------------------------------
# ElastiCache / DynamoDB / SQS
# ------------------------------------------------------------------------------
output "redis_endpoint" {
  description = "Endpoint primário do Redis."
  value       = module.elasticache.primary_endpoint_address
}

output "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB."
  value       = module.dynamodb.table_name
}

output "sqs_queue_url" {
  description = "URL da fila SQS."
  value       = module.sqs.queue_url
}

# ------------------------------------------------------------------------------
# IRSA
# ------------------------------------------------------------------------------
output "analytics_irsa_role_arn" {
  description = "ARN da role IRSA do analytics-service (anotar no ServiceAccount)."
  value       = module.irsa.analytics_role_arn
}

output "evaluation_irsa_role_arn" {
  description = "ARN da role IRSA do evaluation-service (anotar no ServiceAccount)."
  value       = module.irsa.evaluation_role_arn
}

# ------------------------------------------------------------------------------
# GitHub Actions
# ------------------------------------------------------------------------------
output "github_actions_role_arn" {
  description = "ARN da role do GitHub Actions. Configure como variável AWS_ROLE_ARN no repositório."
  value       = module.github_oidc.role_arn
}
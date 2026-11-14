output "repository_urls" {
  description = "Mapa nome do repositório -> URL do ECR."
  value       = { for name, repo in aws_ecr_repository.this : name => repo.repository_url }
}

output "repository_arns" {
  description = "Mapa nome do repositório -> ARN do ECR."
  value       = { for name, repo in aws_ecr_repository.this : name => repo.arn }
}

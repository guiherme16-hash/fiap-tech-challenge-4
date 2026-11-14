output "role_arn" {
  description = "ARN da role assumida pelo GitHub Actions (setar como variável AWS_ROLE_ARN no repo)."
  value       = aws_iam_role.github_actions.arn
}

output "oidc_provider_arn" {
  description = "ARN do OIDC provider do GitHub."
  value       = local.oidc_provider_arn
}

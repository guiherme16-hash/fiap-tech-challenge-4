output "analytics_role_arn" {
  description = "ARN da role IRSA do analytics-service (anotar no ServiceAccount)."
  value       = aws_iam_role.analytics.arn
}

output "evaluation_role_arn" {
  description = "ARN da role IRSA do evaluation-service (anotar no ServiceAccount)."
  value       = aws_iam_role.evaluation.arn
}

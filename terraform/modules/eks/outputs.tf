output "cluster_name" {
  description = "Nome do cluster EKS."
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "Endpoint da API do cluster."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "CA (base64) do cluster para kubeconfig."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_security_group_id" {
  description = "Security group gerenciado pelo EKS e anexado aos nós (fonte para RDS/Redis)."
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "oidc_provider_arn" {
  description = "ARN do OIDC provider (para IRSA)."
  value       = aws_iam_openid_connect_provider.oidc.arn
}

output "oidc_issuer_url" {
  description = "URL do issuer OIDC sem o prefixo https:// (para condições de trust do IRSA)."
  value       = replace(aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")
}

output "node_role_arn" {
  description = "ARN da role IAM dos nós."
  value       = aws_iam_role.node.arn
}

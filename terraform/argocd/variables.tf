variable "aws_region" {
  description = "Região AWS do cluster."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Perfil da AWS CLI a usar (vazio = cadeia padrão/AWS_PROFILE)."
  type        = string
  default     = ""
}

variable "allowed_account_ids" {
  description = "IDs de conta AWS permitidos (trava de segurança). Vazio = sem restrição."
  type        = list(string)
  default     = []
}

variable "cluster_name" {
  description = "Nome do cluster EKS (igual ao output cluster_name do projeto principal)."
  type        = string
  default     = "togglemaster-prod-eks"
}

variable "argocd_namespace" {
  description = "Namespace onde o ArgoCD será instalado."
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "Versão do chart Helm argo-cd. Null = mais recente."
  type        = string
  default     = null
}

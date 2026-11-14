variable "name_prefix" {
  description = "Prefixo de nomes/tags."
  type        = string
}

variable "github_owner" {
  description = "Org/usuário do GitHub (ex: FIAP-TCs)."
  type        = string
}

variable "subject_repositories" {
  description = "Repositórios autorizados a assumir a role (formato: nome do repo)."
  type        = list(string)
}

variable "ecr_repository_arns" {
  description = "ARNs dos repositórios ECR nos quais o GitHub Actions pode dar push."
  type        = list(string)
}

variable "create_oidc_provider" {
  description = "Cria o OIDC provider do GitHub. Defina false se já existir um na conta."
  type        = bool
  default     = true
}

variable "subject_patterns" {
  description = "Sobrescreve os padrões de sub OIDC. Necessário quando o claim sub do GitHub é customizado (ex: inclui IDs numéricos: owner@id/repo@id)."
  type        = list(string)
  default     = []
}

variable "allowed_refs" {
  description = "Refs autorizadas por repo (ex: * para qualquer, ou ref:refs/heads/main)."
  type        = string
  default     = "*"
}

# ------------------------------------------------------------------------------
# Gerais
# ------------------------------------------------------------------------------
variable "aws_region" {
  description = "Região AWS onde toda a infraestrutura será provisionada."
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

variable "project_name" {
  description = "Nome do projeto, usado como prefixo em nomes e tags."
  type        = string
  default     = "togglemaster"
}

variable "environment" {
  description = "Ambiente lógico (ex: prod, staging, dev)."
  type        = string
  default     = "prod"
}

# ------------------------------------------------------------------------------
# Networking
# ------------------------------------------------------------------------------
variable "vpc_cidr" {
  description = "Bloco CIDR da VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Zonas de disponibilidade usadas para as subnets."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDRs das subnets públicas (uma por AZ)."
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.16.0/20"]
}

variable "private_subnet_cidrs" {
  description = "CIDRs das subnets privadas (uma por AZ)."
  type        = list(string)
  default     = ["10.0.128.0/20", "10.0.144.0/20"]
}

variable "single_nat_gateway" {
  description = "Se true, usa um único NAT Gateway (mais barato). Se false, um por AZ (mais resiliente)."
  type        = bool
  default     = true
}

# ------------------------------------------------------------------------------
# EKS
# ------------------------------------------------------------------------------
variable "kubernetes_version" {
  description = "Versão do Kubernetes do cluster EKS."
  type        = string
  default     = "1.31"
}

variable "node_instance_types" {
  description = "Tipos de instância EC2 para o node group gerenciado."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Quantidade desejada de nós no node group."
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Quantidade mínima de nós no node group."
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Quantidade máxima de nós no node group."
  type        = number
  default     = 3
}

variable "eks_public_access" {
  description = "Habilita acesso público ao endpoint da API do EKS."
  type        = bool
  default     = true
}

# ------------------------------------------------------------------------------
# RDS (PostgreSQL)
# ------------------------------------------------------------------------------
variable "databases" {
  description = "Mapa de bancos PostgreSQL a criar (uma instância RDS por chave)."
  type = map(object({
    db_name = string
  }))
  default = {
    auth      = { db_name = "auth_db" }
    flags     = { db_name = "flags_db" }
    targeting = { db_name = "targeting_db" }
  }
}

variable "rds_engine_version" {
  description = "Versão do engine PostgreSQL (aceita major-only, ex: 16)."
  type        = string
  default     = "16"
}

variable "rds_instance_class" {
  description = "Classe de instância das bases RDS."
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "Armazenamento alocado (GB) por instância RDS."
  type        = number
  default     = 20
}

variable "rds_master_username" {
  description = "Usuário master das instâncias PostgreSQL."
  type        = string
  default     = "postgres"
}

# ------------------------------------------------------------------------------
# ElastiCache (Redis)
# ------------------------------------------------------------------------------
variable "redis_node_type" {
  description = "Tipo de nó do cluster ElastiCache Redis."
  type        = string
  default     = "cache.t3.micro"
}

variable "redis_engine_version" {
  description = "Versão do engine Redis."
  type        = string
  default     = "7.1"
}

# ------------------------------------------------------------------------------
# DynamoDB / SQS
# ------------------------------------------------------------------------------
variable "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB de analytics."
  type        = string
  default     = "ToggleMasterAnalytics"
}

variable "sqs_queue_name" {
  description = "Nome da fila SQS de eventos de avaliação."
  type        = string
  default     = "analytics-service-sqs"
}

# ------------------------------------------------------------------------------
# ECR
# ------------------------------------------------------------------------------
variable "ecr_repositories" {
  description = "Lista de repositórios ECR (um por microsserviço)."
  type        = list(string)
  default = [
    "auth-service",
    "flag-service",
    "targeting-service",
    "evaluation-service",
    "analytics-service",
  ]
}

# ------------------------------------------------------------------------------
# IRSA (IAM Roles for Service Accounts)
# Namespaces/ServiceAccounts que os pods usarão. Os ServiceAccounts serão
# criados no bloco de GitOps (Fase 3 - CD) com a anotação do ARN da role.
# ------------------------------------------------------------------------------
variable "analytics_namespace" {
  description = "Namespace do analytics-service no cluster."
  type        = string
  default     = "tc2-analytics"
}

variable "analytics_service_account" {
  description = "ServiceAccount usado pelo analytics-service (IRSA)."
  type        = string
  default     = "tc2-analytics-sa"
}

variable "evaluation_namespace" {
  description = "Namespace do evaluation-service no cluster."
  type        = string
  default     = "tc2-evaluation"
}

variable "evaluation_service_account" {
  description = "ServiceAccount usado pelo evaluation-service (IRSA)."
  type        = string
  default     = "tc2-evaluation-sa"
}

# ------------------------------------------------------------------------------
# GitHub Actions (OIDC para push no ECR)
# ------------------------------------------------------------------------------
variable "github_owner" {
  description = "Org/usuário do GitHub dono do repositório monorepo."
  type        = string
  default     = "FIAP-TCs"
}

variable "github_repo" {
  description = "Nome do repositório monorepo no GitHub (onde ficam os workflows)."
  type        = string
  default     = "fiap-tech-challenge-4"
}

variable "create_github_oidc_provider" {
  description = "Cria o OIDC provider do GitHub. Defina false se já existir um na conta AWS."
  type        = bool
  default     = true
}

variable "github_subject_patterns" {
  description = "Sobrescreve os padrões de sub OIDC (quando o claim sub do GitHub inclui IDs, ex: owner@id/repo@id)."
  type        = list(string)
  default     = []
}

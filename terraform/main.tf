locals {
  name_prefix  = "${var.project_name}-${var.environment}"
  cluster_name = "${var.project_name}-${var.environment}-eks"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ------------------------------------------------------------------------------
# Networking: VPC, subnets públicas/privadas, IGW, NAT e route tables.
# ------------------------------------------------------------------------------
module "networking" {
  source = "./modules/networking"

  name_prefix          = local.name_prefix
  cluster_name         = local.cluster_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  single_nat_gateway   = var.single_nat_gateway
}

# ------------------------------------------------------------------------------
# ECR: um repositório por microsserviço.
# ------------------------------------------------------------------------------
module "ecr" {
  source = "./modules/ecr"

  name_prefix      = local.name_prefix
  repository_names = var.ecr_repositories
}

# ------------------------------------------------------------------------------
# EKS: cluster, node group gerenciado, OIDC provider e addons.
# ------------------------------------------------------------------------------
module "eks" {
  source = "./modules/eks"

  cluster_name           = local.cluster_name
  kubernetes_version     = var.kubernetes_version
  vpc_id                 = module.networking.vpc_id
  private_subnet_ids     = module.networking.private_subnet_ids
  public_subnet_ids      = module.networking.public_subnet_ids
  node_instance_types    = var.node_instance_types
  node_desired_size      = var.node_desired_size
  node_min_size          = var.node_min_size
  node_max_size          = var.node_max_size
  endpoint_public_access = var.eks_public_access
}

# ------------------------------------------------------------------------------
# RDS: 3 instâncias PostgreSQL, senhas em Secrets Manager.
# ------------------------------------------------------------------------------
module "rds" {
  source = "./modules/rds"

  name_prefix                = local.name_prefix
  databases                  = var.databases
  vpc_id                     = module.networking.vpc_id
  subnet_ids                 = module.networking.private_subnet_ids
  allowed_security_group_ids = [module.eks.cluster_security_group_id]
  engine_version             = var.rds_engine_version
  instance_class             = var.rds_instance_class
  allocated_storage          = var.rds_allocated_storage
  master_username            = var.rds_master_username
}

# ------------------------------------------------------------------------------
# ElastiCache: cluster Redis para o evaluation-service.
# ------------------------------------------------------------------------------
module "elasticache" {
  source = "./modules/elasticache"

  name_prefix                = local.name_prefix
  vpc_id                     = module.networking.vpc_id
  subnet_ids                 = module.networking.private_subnet_ids
  allowed_security_group_ids = [module.eks.cluster_security_group_id]
  node_type                  = var.redis_node_type
  engine_version             = var.redis_engine_version
}

# ------------------------------------------------------------------------------
# DynamoDB: tabela de analytics.
# ------------------------------------------------------------------------------
module "dynamodb" {
  source = "./modules/dynamodb"

  table_name = var.dynamodb_table_name
}

# ------------------------------------------------------------------------------
# SQS: fila de eventos de avaliação + DLQ.
# ------------------------------------------------------------------------------
module "sqs" {
  source = "./modules/sqs"

  name_prefix = local.name_prefix
  queue_name  = var.sqs_queue_name
}

# ------------------------------------------------------------------------------
# IRSA: roles IAM associadas a ServiceAccounts (evita chaves AWS em texto plano).
#   - analytics: consome SQS e grava no DynamoDB
#   - evaluation: envia mensagens para o SQS
# ------------------------------------------------------------------------------
module "irsa" {
  source = "./modules/irsa"

  name_prefix        = local.name_prefix
  oidc_provider_arn  = module.eks.oidc_provider_arn
  oidc_issuer_url    = module.eks.oidc_issuer_url
  dynamodb_table_arn = module.dynamodb.table_arn
  sqs_queue_arn      = module.sqs.queue_arn

  analytics_namespace        = var.analytics_namespace
  analytics_service_account  = var.analytics_service_account
  evaluation_namespace       = var.evaluation_namespace
  evaluation_service_account = var.evaluation_service_account
}

# ------------------------------------------------------------------------------
# GitHub OIDC: role assumida pelo GitHub Actions para dar push no ECR (sem chaves).
# ------------------------------------------------------------------------------
module "github_oidc" {
  source = "./modules/github-oidc"

  name_prefix          = local.name_prefix
  github_owner         = var.github_owner
  subject_repositories = [var.github_repo]
  subject_patterns     = var.github_subject_patterns
  ecr_repository_arns  = values(module.ecr.repository_arns)
  create_oidc_provider = var.create_github_oidc_provider
}

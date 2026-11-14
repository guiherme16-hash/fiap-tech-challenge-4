variable "name_prefix" {
  description = "Prefixo de nomes/tags."
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN do OIDC provider do cluster EKS."
  type        = string
}

variable "oidc_issuer_url" {
  description = "URL do issuer OIDC (sem https://)."
  type        = string
}

variable "dynamodb_table_arn" {
  description = "ARN da tabela DynamoDB de analytics."
  type        = string
}

variable "sqs_queue_arn" {
  description = "ARN da fila SQS de eventos."
  type        = string
}

variable "analytics_namespace" {
  description = "Namespace do analytics-service."
  type        = string
}

variable "analytics_service_account" {
  description = "ServiceAccount do analytics-service."
  type        = string
}

variable "evaluation_namespace" {
  description = "Namespace do evaluation-service."
  type        = string
}

variable "evaluation_service_account" {
  description = "ServiceAccount do evaluation-service."
  type        = string
}

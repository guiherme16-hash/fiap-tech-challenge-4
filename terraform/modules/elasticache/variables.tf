variable "name_prefix" {
  description = "Prefixo de nomes/tags."
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets (privadas) para o subnet group do Redis."
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "Security groups que podem acessar o Redis (ex: SG do cluster EKS)."
  type        = list(string)
  default     = []
}

variable "node_type" {
  description = "Tipo de nó do Redis."
  type        = string
  default     = "cache.t3.micro"
}

variable "engine_version" {
  description = "Versão do engine Redis."
  type        = string
  default     = "7.1"
}

variable "num_cache_clusters" {
  description = "Número de nós (1 = sem réplica). >1 habilita failover automático."
  type        = number
  default     = 1
}

variable "parameter_group_name" {
  description = "Parameter group do Redis."
  type        = string
  default     = "default.redis7"
}

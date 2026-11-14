variable "name_prefix" {
  description = "Prefixo de nomes/tags."
  type        = string
}

variable "databases" {
  description = "Mapa de bancos a criar (uma instância RDS por chave)."
  type = map(object({
    db_name = string
  }))
}

variable "vpc_id" {
  description = "ID da VPC."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets (privadas) para o DB subnet group."
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "Security groups que podem acessar o PostgreSQL (ex: SG do cluster EKS)."
  type        = list(string)
  default     = []
}

variable "engine_version" {
  description = "Versão do engine PostgreSQL (aceita major-only, ex: 16)."
  type        = string
  default     = "16"
}

variable "instance_class" {
  description = "Classe de instância."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Armazenamento inicial (GB)."
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Teto de autoscaling de storage (GB). 0 desabilita."
  type        = number
  default     = 100
}

variable "master_username" {
  description = "Usuário master do PostgreSQL."
  type        = string
  default     = "postgres"
}

variable "multi_az" {
  description = "Habilita Multi-AZ (mais caro, mais resiliente)."
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Dias de retenção de backup."
  type        = number
  default     = 1
}

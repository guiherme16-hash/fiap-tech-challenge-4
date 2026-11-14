variable "name_prefix" {
  description = "Prefixo de projeto (usado em tags)."
  type        = string
}

variable "repository_names" {
  description = "Nomes dos repositórios ECR a criar."
  type        = list(string)
}

variable "image_tag_mutability" {
  description = "Mutabilidade das tags de imagem (MUTABLE ou IMMUTABLE)."
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Habilita scan de vulnerabilidades no push (usado pelo pipeline DevSecOps)."
  type        = bool
  default     = true
}

variable "untagged_expiry_days" {
  description = "Dias para expirar imagens sem tag (lifecycle policy)."
  type        = number
  default     = 14
}

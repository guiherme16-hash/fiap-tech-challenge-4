variable "aws_region" {
  description = "Região AWS onde o bucket de state será criado."
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
  description = "Nome do projeto (prefixo do bucket de state)."
  type        = string
  default     = "togglemaster"
}

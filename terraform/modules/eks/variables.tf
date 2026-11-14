variable "cluster_name" {
  description = "Nome do cluster EKS."
  type        = string
}

variable "kubernetes_version" {
  description = "Versão do Kubernetes."
  type        = string
  default     = "1.31"
}

variable "vpc_id" {
  description = "ID da VPC (reservado para uso futuro/documentação)."
  type        = string
  default     = null
}

variable "private_subnet_ids" {
  description = "Subnets privadas (onde ficam os nós)."
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Subnets públicas (para ELBs públicos)."
  type        = list(string)
  default     = []
}

variable "endpoint_public_access" {
  description = "Habilita acesso público ao endpoint da API do cluster."
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "CIDRs autorizados a acessar o endpoint público da API."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "authentication_mode" {
  description = "Modo de autenticação do cluster (API, API_AND_CONFIG_MAP ou CONFIG_MAP)."
  type        = string
  default     = "API_AND_CONFIG_MAP"
}

variable "cluster_log_types" {
  description = "Tipos de log do control plane enviados ao CloudWatch. Lista vazia desabilita."
  type        = list(string)
  default     = ["api", "audit", "authenticator"]
}

# --- Node group ---
variable "node_instance_types" {
  description = "Tipos de instância dos nós."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Quantidade desejada de nós."
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Quantidade mínima de nós."
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Quantidade máxima de nós."
  type        = number
  default     = 3
}

variable "capacity_type" {
  description = "ON_DEMAND ou SPOT."
  type        = string
  default     = "ON_DEMAND"
}

variable "ami_type" {
  description = "Tipo de AMI dos nós."
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "disk_size" {
  description = "Tamanho do disco (GB) dos nós."
  type        = number
  default     = 20
}

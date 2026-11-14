variable "name_prefix" {
  description = "Prefixo de nomes/tags."
  type        = string
}

variable "cluster_name" {
  description = "Nome do cluster EKS (usado nas tags de subnet para descoberta de load balancers)."
  type        = string
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC."
  type        = string
}

variable "availability_zones" {
  description = "Zonas de disponibilidade."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDRs das subnets públicas (uma por AZ)."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDRs das subnets privadas (uma por AZ)."
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "Um único NAT Gateway (true) ou um por AZ (false)."
  type        = bool
  default     = true
}

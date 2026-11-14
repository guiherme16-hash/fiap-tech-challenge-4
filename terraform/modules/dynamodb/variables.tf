variable "table_name" {
  description = "Nome da tabela DynamoDB."
  type        = string
}

variable "hash_key" {
  description = "Chave de partição. O analytics-service usa event_id (UUID)."
  type        = string
  default     = "event_id"
}

variable "billing_mode" {
  description = "Modo de cobrança (PAY_PER_REQUEST evita capacidade provisionada)."
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "point_in_time_recovery" {
  description = "Habilita PITR (recuperação ponto-a-ponto)."
  type        = bool
  default     = true
}

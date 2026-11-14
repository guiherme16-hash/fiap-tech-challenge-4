variable "name_prefix" {
  description = "Prefixo de projeto (usado em tags)."
  type        = string
}

variable "queue_name" {
  description = "Nome da fila SQS principal."
  type        = string
}

variable "visibility_timeout_seconds" {
  description = "Tempo de invisibilidade da mensagem após recebida."
  type        = number
  default     = 30
}

variable "message_retention_seconds" {
  description = "Retenção de mensagens na fila principal (segundos)."
  type        = number
  default     = 345600
}

variable "receive_wait_time_seconds" {
  description = "Long polling: espera por mensagens (segundos). O analytics usa 20."
  type        = number
  default     = 20
}

variable "max_receive_count" {
  description = "Tentativas antes de mandar a mensagem para a DLQ."
  type        = number
  default     = 5
}

variable "dlq_retention_seconds" {
  description = "Retenção de mensagens na DLQ (segundos)."
  type        = number
  default     = 1209600
}

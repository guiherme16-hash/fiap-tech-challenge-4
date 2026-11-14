output "primary_endpoint_address" {
  description = "Endpoint primário do Redis."
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "port" {
  description = "Porta do Redis."
  value       = 6379
}

output "security_group_id" {
  description = "ID do security group do Redis."
  value       = aws_security_group.redis.id
}

output "instance_endpoints" {
  description = "Endpoints (host:porta) das instâncias RDS por banco."
  value       = { for k, db in aws_db_instance.this : k => db.endpoint }
}

output "instance_addresses" {
  description = "Hostnames das instâncias RDS por banco."
  value       = { for k, db in aws_db_instance.this : k => db.address }
}

output "secret_arns" {
  description = "ARNs dos secrets (Secrets Manager) por banco."
  value       = { for k, s in aws_secretsmanager_secret.db : k => s.arn }
}

output "security_group_id" {
  description = "ID do security group das instâncias RDS."
  value       = aws_security_group.rds.id
}

output "port" {
  description = "Porta do PostgreSQL."
  value       = 5432
}

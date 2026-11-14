output "state_bucket_name" {
  description = "Nome do bucket S3 do state remoto."
  value       = aws_s3_bucket.tfstate.bucket
}

output "backend_config_hint" {
  description = "Linha de configuração do bucket para o backend."
  value       = "bucket = \"${aws_s3_bucket.tfstate.bucket}\""
}

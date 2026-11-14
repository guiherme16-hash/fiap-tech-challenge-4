# Backend remoto no S3 com travamento nativo (use_lockfile), sem tabela DynamoDB.
# O nome do bucket vem via configuração parcial (backend.hcl), pois backends não
# aceitam variáveis.
terraform {
  backend "s3" {
    key          = "togglemaster/phase3/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

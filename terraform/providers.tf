provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile != "" ? var.aws_profile : null

  # Trava de segurança: se as credenciais resolverem para outra conta
  # (ex: perfil de trabalho), o Terraform falha em vez de tocar nela.
  allowed_account_ids = length(var.allowed_account_ids) > 0 ? var.allowed_account_ids : null

  # Tags aplicadas automaticamente a todos os recursos suportados.
  default_tags {
    tags = local.common_tags
  }
}

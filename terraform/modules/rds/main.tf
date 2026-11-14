# ------------------------------------------------------------------------------
# Subnet group + Security group compartilhados pelas instâncias RDS
# ------------------------------------------------------------------------------
resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-rds"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.name_prefix}-rds-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name_prefix = "${var.name_prefix}-rds-"
  description = "Acesso PostgreSQL a partir do cluster EKS"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-rds-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rds_ingress" {
  count                    = length(var.allowed_security_group_ids)
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = var.allowed_security_group_ids[count.index]
  description              = "PostgreSQL a partir do EKS"
}

resource "aws_security_group_rule" "rds_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.rds.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Saida liberada (egress)"
}

# ------------------------------------------------------------------------------
# Senhas aleatórias (evita credenciais em texto plano)
# ------------------------------------------------------------------------------
resource "random_password" "db" {
  for_each = var.databases

  length  = 20
  special = true
  # Evita caracteres não aceitos pelo RDS ( / @ " e espaço ).
  override_special = "!#$%*()-_=+[]{}:?"
}

# ------------------------------------------------------------------------------
# Instâncias RDS PostgreSQL (uma por banco)
# ------------------------------------------------------------------------------
resource "aws_db_instance" "this" {
  for_each = var.databases

  identifier     = "${var.name_prefix}-${each.key}"
  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage > 0 ? var.max_allocated_storage : null
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = each.value.db_name
  username = var.master_username
  password = random_password.db[each.key].result
  port     = 5432

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  multi_az            = var.multi_az
  publicly_accessible = false

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = true
  deletion_protection     = false
  apply_immediately       = true

  tags = {
    Name = "${var.name_prefix}-${each.key}"
  }
}

# ------------------------------------------------------------------------------
# Secrets Manager: guarda as credenciais de cada base (username/senha/host/URL)
# ------------------------------------------------------------------------------
resource "aws_secretsmanager_secret" "db" {
  for_each = var.databases

  name                    = "${var.name_prefix}/rds/${each.key}"
  description             = "Credenciais RDS PostgreSQL - ${each.key}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db" {
  for_each = var.databases

  secret_id = aws_secretsmanager_secret.db[each.key].id
  secret_string = jsonencode({
    username = var.master_username
    password = random_password.db[each.key].result
    engine   = "postgres"
    host     = aws_db_instance.this[each.key].address
    port     = aws_db_instance.this[each.key].port
    dbname   = each.value.db_name
    url      = "postgres://${var.master_username}:${random_password.db[each.key].result}@${aws_db_instance.this[each.key].address}:${aws_db_instance.this[each.key].port}/${each.value.db_name}?sslmode=require"
  })
}

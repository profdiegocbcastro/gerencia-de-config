resource "aws_db_instance" "postgres" {
  identifier          = "alunos-db"
  engine              = "postgres"
  engine_version      = "15"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  db_name             = "alunos"
  username            = "postgres"
  password            = var.db_password
  skip_final_snapshot = true
  publicly_accessible = true
}

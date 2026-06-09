variable "db_user" {
  type    = string
  default = "admin"
}

variable "db_password" {
  type      = string
  default   = "senha123"
  sensitive = true
}

output "instance_public_ip" {
  description = "IP da instancia EC2 criada pelo Floci"
  value       = aws_instance.api_server.public_ip
}

output "private_key_path" {
  description = "Caminho da chave SSH gerada"
  value       = local_sensitive_file.private_key.filename
}

output "api_url" {
  description = "URL do API Gateway"
  value       = aws_apigatewayv2_stage.default.invoke_url
}

output "rds_endpoint" {
  description = "Endpoint do RDS criado pelo Floci"
  value       = aws_db_instance.postgres.address
}

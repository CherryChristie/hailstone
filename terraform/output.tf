output "api_endpoint" {
  value       = aws_apigatewayv2_api.api.api_endpoint
  description = "The public API endpoint of the deployed Lambda"
}

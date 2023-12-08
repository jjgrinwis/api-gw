output "url" {
  description = "API-GW url with the resource"
  value       = aws_api_gateway_stage.example.invoke_url
}
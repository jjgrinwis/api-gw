output "backend_url" {
  description = "API-GW url with the resource"
  value       = aws_api_gateway_stage.example.invoke_url
}

output "frontend_url" {
  description = "The frontend URL to use"
  value = "${var.api-gw-hostname}.${var.zone-name}"
}

output "target" {
  description = "The frontend URL to use"
  value = var.target
}


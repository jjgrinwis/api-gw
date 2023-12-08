# we created a user in IAM with AmazonAPIGatewayAdministrator permission 
# and add security credentials and use that in 'aws configure'
resource "aws_api_gateway_rest_api" "MyDemoAPI" {
  name        = "MyWargamesAPI"
  description = "wargames api-gw setup"
}

resource "aws_api_gateway_method" "MyDemoMethod" {
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id   = aws_api_gateway_rest_api.MyDemoAPI.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.header.user-agent" = true
  }
}

resource "aws_api_gateway_integration" "MyDemoIntegration" {
  rest_api_id             = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id             = aws_api_gateway_rest_api.MyDemoAPI.root_resource_id
  http_method             = aws_api_gateway_method.MyDemoMethod.http_method
  integration_http_method = aws_api_gateway_method.MyDemoMethod.http_method
  uri                     = var.target
  type                    = "HTTP"
  request_parameters = {
    "integration.request.header.User-Agent" = "method.request.header.user-agent"
  }
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id = aws_api_gateway_rest_api.MyDemoAPI.root_resource_id
  http_method = aws_api_gateway_method.MyDemoMethod.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id = aws_api_gateway_rest_api.MyDemoAPI.root_resource_id
  http_method = aws_api_gateway_method.MyDemoMethod.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

}

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.MyDemoAPI.root_resource_id,
      aws_api_gateway_method.MyDemoMethod.id,
      aws_api_gateway_integration.MyDemoIntegration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  stage_name    = "wargame"
}
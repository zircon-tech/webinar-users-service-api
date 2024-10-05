# Create API Gateway REST API
resource "aws_api_gateway_rest_api" "service_api" {
  name        = "${var.project_name}-api"
  description = "API Gateway for service Lambda function"
}

# Create a resource in API Gateway
resource "aws_api_gateway_resource" "service_resource" {
  rest_api_id = aws_api_gateway_rest_api.service_api.id
  parent_id   = aws_api_gateway_rest_api.service_api.root_resource_id
  path_part   = "users"  # This will be the path for the API
}

# Create the method for the resource (GET, POST, etc.)
resource "aws_api_gateway_method" "service_method" {
  rest_api_id   = aws_api_gateway_rest_api.service_api.id
  resource_id   = aws_api_gateway_resource.service_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integrate the method with Lambda function
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.service_api.id
  resource_id             = aws_api_gateway_resource.service_resource.id
  http_method             = aws_api_gateway_method.service_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.service_function.invoke_arn
}

# Allow API Gateway to invoke the Lambda function
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.service_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.service_api.execution_arn}/*/*"
}

# Create deployment for the API Gateway
resource "aws_api_gateway_deployment" "service_deployment" {
  depends_on = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.service_api.id
  stage_name  = "prod"
}

# Output the API Gateway endpoint
output "api_gateway_url" {
  value = "${aws_api_gateway_deployment.service_deployment.invoke_url}/users"
  description = "API Gateway endpoint URL"
}

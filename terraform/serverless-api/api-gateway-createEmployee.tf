resource "aws_api_gateway_resource" "createEmployee" {
  path_part   = aws_lambda_function.createEmployee.function_name
  parent_id   = aws_api_gateway_rest_api.serverless_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
}

resource "aws_api_gateway_method" "createEmployee" {
  rest_api_id   = aws_api_gateway_rest_api.serverless_api.id
  resource_id   = aws_api_gateway_resource.createEmployee.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "createEmployee" {
  rest_api_id             = aws_api_gateway_rest_api.serverless_api.id
  resource_id             = aws_api_gateway_resource.createEmployee.id
  http_method             = aws_api_gateway_method.createEmployee.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.createEmployee.invoke_arn
}

resource "aws_api_gateway_deployment" "createEmployee" {
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
  stage_name  = "prod"

  triggers = {
    redeployment = sha1(join(",", list(
      jsonencode(aws_api_gateway_integration.createEmployee),
    )))
  }
}

resource "aws_lambda_permission" "createEmployee" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.createEmployee.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.serverless_api.execution_arn}/*/*/*"
}

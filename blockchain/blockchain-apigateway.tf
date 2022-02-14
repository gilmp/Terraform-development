#### This is about creating a apigateway for blockchain connection ####

resource "aws_apigatewayv2_api" "blockchain_lambda" {
  name = "blockchain_gw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "blockchain_lambda" {
  api_id = aws_apigatewayv2_api.blockchain_lambda.id
  name = "blockchain_gw_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    }
  )
}
}

resource "aws_apigatewayv2_integration" "blockchain_hello_world" {
  api_id = aws_apigatewayv2_api.blockchain_lambda.id

  integration_uri    = aws_lambda_function.blockchain_hello_world.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}


resource "aws_apigatewayv2_route" "blockchain_hello_world" {
  api_id = aws_apigatewayv2_api.blockchain_lambda.id

  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.blockchain_hello_world.id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.blockchain_lambda.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.blockchain_hello_world.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.blockchain_lambda.execution_arn}/*/*"
}
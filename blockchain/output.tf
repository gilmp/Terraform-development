output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.blockchain_hello_world.function_name
}
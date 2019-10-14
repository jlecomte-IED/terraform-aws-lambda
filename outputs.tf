output "lambda_function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "lambda_arn" {
  value = aws_lambda_function.lambda.arn
}

output "lambda_invocation_result" {
  description = "String result of Lambda execution"
  value       = "${data.aws_lambda_invocation.run_lambda[0].result}"
}

output "lambda_version" {
  value = aws_lambda_function.lambda.version
}

output "lambda_role_name" {
  value = aws_iam_role.lambda.name
}

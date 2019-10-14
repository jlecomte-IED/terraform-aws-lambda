data "aws_iam_policy" "aws_lambda_vpc_access" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

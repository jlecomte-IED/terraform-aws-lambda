data "aws_iam_policy_document" "role_policy" {
  statement {
    sid = "LambdaAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
      ]
    }
    principals {
      type = "AWS"
      identifiers = [
        var.default_account_arn,
        var.security_account_arn,
      ]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = local.lambda_function_name
  assume_role_policy = data.aws_iam_policy_document.role_policy.json
}

# Policies Attachment
resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.lambda.name
  policy_arn = data.aws_iam_policy.aws_lambda_vpc_access.arn
}

resource "aws_lambda_function" "lambda" {
  depends_on = [
    aws_iam_role.lambda,
    aws_cloudwatch_log_group.lambda
  ]

  function_name    = local.lambda_function_name
  source_code_hash = filebase64sha256(var.lambda_filepath)

  publish = true

  s3_bucket = data.aws_s3_bucket.deployment_bucket.id
  s3_key    = var.lambda_bucket_key

  handler = var.lambda_handler
  runtime = var.lambda_runtime

  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory_size

  vpc_config {
    subnet_ids         = var.vpc["subnet_ids"]
    security_group_ids = var.vpc["security_group_ids"]
  }

  tags = "${var.common_tags}"

  environment {
    variables = var.environment
  }

  role = aws_iam_role.lambda.arn
}

# Call the lambda function
data "aws_lambda_invocation" "run_lambda" {
  count         = var.enable_invocation ? 1 : 0
  depends_on    = [aws_lambda_function.lambda]
  function_name = "${aws_lambda_function.lambda.function_name}"

  input = <<JSON
{}
JSON
}

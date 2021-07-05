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
  name               = local.lambda_role_name
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
    aws_cloudwatch_log_group.lambda,
    aws_sqs_queue.lambda_dead_letter_queue,
    aws_iam_role_policy_attachment.lambda_publish_to_sqs_dlq
  ]

  function_name    = local.lambda_function_name
  source_code_hash = filebase64sha256(var.lambda_filepath)

  publish = var.lambda_publish

  s3_bucket = data.aws_s3_bucket.deployment_bucket.id
  s3_key    = var.lambda_bucket_key

  handler = var.lambda_handler
  runtime = var.lambda_runtime
  layers  = var.lambda_layers

  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory_size

  vpc_config {
    subnet_ids         = var.vpc["subnet_ids"]
    security_group_ids = var.vpc["security_group_ids"]
  }

  tags = var.common_tags

  reserved_concurrent_executions = var.lambda_reserved_concurrent_executions

  environment {
    variables = var.environment
  }

  dynamic dead_letter_config {
    for_each = var.enable_dead_letter_queue ? [true] : []
    content {
      target_arn = aws_sqs_queue.lambda_dead_letter_queue[0].arn
    }
  }

  role = aws_iam_role.lambda.arn
}

resource "aws_lambda_function_event_invoke_config" "lambda" {
  function_name                = aws_lambda_function.lambda.function_name
  maximum_retry_attempts       = var.lambda_max_retry
  maximum_event_age_in_seconds = var.lambda_maximum_event_age_in_seconds
}

# Call the lambda function
data "aws_lambda_invocation" "run_lambda" {
  count = var.enable_invocation ? 1 : 0

  depends_on    = [aws_lambda_function.lambda]
  function_name = aws_lambda_function.lambda.function_name

  input = <<JSON
{}
JSON
}

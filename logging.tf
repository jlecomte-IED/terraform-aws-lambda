data "aws_iam_policy_document" "lambda_logging" {

  statement {
    sid = "${local.camel_app_name}LambdaLogging${title(var.stage)}"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:/aws/lambda/${var.stage}-${var.app_name}-*",
    ]

    effect = "Allow"
  }
}

data "aws_lambda_function" "logs_to_kibana" {
  function_name = var.lambda_logs_to_kibana_name
}

resource "aws_cloudwatch_log_group" "lambda" {
  name = "/aws/lambda/${var.stage}-${var.app_name}-${var.lambda_cannonicalname}"
}

resource "aws_cloudwatch_log_subscription_filter" "logs_to_kibana" {
  name            = var.logs_to_kibana_subscription_filter_name
  log_group_name  = aws_cloudwatch_log_group.lambda.name
  filter_pattern  = ""
  destination_arn = data.aws_lambda_function.logs_to_kibana.arn
}

resource "aws_iam_policy" "lambda_logging" {
  description = "Policy to allow the lambda to create and publish logs in cloudwatch"
  name        = "${var.stage}-${var.app_name}-lambda-logs"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  depends_on = ["aws_iam_policy.lambda_logging"]
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}


resource "aws_sqs_queue" "lambda_dead_letter_queue" {
  count = "${var.enable_dead_letter_queue ? 1 : 0}"
  name  = "${local.lambda_function_name}-dlq"
  tags  = var.common_tags
}

data "aws_iam_policy_document" "lambda_dead_letter_queue" {
  count = "${var.enable_dead_letter_queue ? 1 : 0}"
  statement {
    sid = "LambdaAccessDLQ"
    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueUrl",
    ]
    effect = "Allow"
    resources = [
      aws_sqs_queue.lambda_dead_letter_queue[0].arn
    ]
  }
}

resource "aws_iam_policy" "lambda_publish_to_sqs_dlq" {
  count  = "${var.enable_dead_letter_queue ? 1 : 0}"
  name   = "${local.lambda_function_name}-publish-to-sqs-dlq"
  policy = data.aws_iam_policy_document.lambda_dead_letter_queue[0].json
}

resource "aws_iam_role_policy_attachment" "lambda_publish_to_sqs_dlq" {
  count      = "${var.enable_dead_letter_queue ? 1 : 0}"
  role       = local.lambda_role_name
  policy_arn = aws_iam_policy.lambda_publish_to_sqs_dlq[0].arn
}

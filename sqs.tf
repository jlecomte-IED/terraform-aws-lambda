
resource "aws_sqs_queue" "lambda_dead_letter_queue" {
  count = "${var.use_deadletter_queue ? 1 : 0}"
  name  = "${lambda_function_name}-dlq"
  tags  = local.common_tags
}

data "aws_iam_policy_document" "lambda_dead_letter_queue" {
  count = "${var.use_deadletter_queue ? 1 : 0}"
  statement {
    sid = "Access-${lambda_function_name}-DLQ"
    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueUrl",
    ]
    effect = "Allow"
    resources = [
      aws_sqs_queue.lambda_dead_letter_queue.arn
    ]
  }
}

resource "aws_iam_policy" "lambda_publish_to_sqs_dlq" {
  count  = "${var.use_deadletter_queue ? 1 : 0}"
  name   = "${var.stage}-${var.app_name}-lambda-publish-to-sqs-dlq"
  policy = data.aws_iam_policy_document.lambda_dead_letter_queue.json
}

resource "aws_iam_role_policy_attachment" "lambda_publish_to_sqs_dlq" {
  count      = "${var.use_deadletter_queue ? 1 : 0}"
  role       = local.lambda_role_name
  policy_arn = aws_iam_policy.lambda_publish_to_sqs_dlq.arn
}

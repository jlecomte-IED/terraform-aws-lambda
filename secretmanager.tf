data "aws_secretsmanager_secret" "secret_manager" {
  count = length(var.secret_managers)
  name  = var.secret_managers[count.index]
}

data "aws_iam_policy_document" "secrets_manager_get_secret" {
  statement {
    sid = "AccessLambdaSecrets"
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    effect    = "Allow"
    resources = [for secret in data.aws_secretsmanager_secret.secret_manager : secret.arn]
  }
}

resource "aws_iam_policy" "secrets_manager_get_secret" {
  name   = "SecretManager-${var.app_name}-${var.stage}-${var.lambda_cannonicalname}"
  policy = data.aws_iam_policy_document.secrets_manager_get_secret.json
}

resource "aws_iam_role_policy_attachment" "secrets_manager_get_secret" {
  depends_on = [aws_iam_policy.secrets_manager_get_secret]

  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.secrets_manager_get_secret.arn
}

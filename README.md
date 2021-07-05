# terraform-aws-lambda

Description : terraform module for deploying a lambda aws (lambda, cloudwatch) in a blink ⚡️

The module inludes the capability to deploy a lambda in PHP thanks to custom layers.

## example

```hcl
module "lambda-deployer" {
  source = "app.terraform.io/ied/lambda/aws"
  version = "~>3.0.0"

  common_tags = local.common_tags
  app_id      = local.app_id
  app_name    = var.app_name
  stage       = var.stage

  vpc                  = var.vpcs[var.stage]
  security_account_arn = var.account_arn_list["security"]
  default_account_arn  = var.account_arn_list[var.stage]

  lambda_cannonicalname = "migrate"
  lambda_filepath       = "../../back-end/lambda.zip"
  lambda_bucket         = var.backend_s3_bucket
  lambda_bucket_key     = var.backend_s3_key
  lambda_handler        = "functions/migrate/index.handler"

  lambda_runtime = "nodejs12.x"
  lambda_timeout = 900

  lambda_logs_to_kibana_name              = var.logs[var.stage][0]
  logs_to_kibana_subscription_filter_name = var.logs[var.stage][1]

  enable_invocation = true

  secret_managers = local.secrets

  environment = {
    STAGE   = var.stage
    RELEASE = var.app_version
  }
 }
```

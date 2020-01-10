# terraform-aws-lambda

Description : terraform module for deploying a lambda aws (lambda, cloudwatch) in a blink ⚡️

The module inludes the capability to deploy a lambda in PHP thanks to custom layers.

## example

```hcl
module "lambda-deployer" {
  source = "./terraform-aws-lambda"

  common_tags = local.common_tags
  app_id      = local.app_id
  app_name    = var.app_name
  stage       = var.stage

  vpc                  = var.vpcs[var.stage]
  security_account_arn = var.account_arn_list["security"]
  default_account_arn  = var.account_arn_list[var.stage]

  lambda_cannonicalname = "release-name-generator"
  lambda_filepath       = "lambda.zip"
  lambda_bucket         = var.backend_s3_bucket
  lambda_bucket_key     = var.backend_s3_key
  lambda_handler        = "index.php"
  lambda_runtime        = "provided"
  lambda_layers         = "arn:aws:lambda:eu-central-1:209497400698:layer:php-74:1"

  lambda_timeout = 30

  lambda_logs_to_kibana_name              = var.logs[var.stage][0]
  logs_to_kibana_subscription_filter_name = var.logs[var.stage][1]

  secret_managers = ["database_password"]

  environment = {
    STAGE = var.stage
  }
 }
```

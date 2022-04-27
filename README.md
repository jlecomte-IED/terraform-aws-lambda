# terraform-aws-lambda

Description : terraform module for deploying a lambda aws (lambda, cloudwatch) in a blink ⚡️

The module inludes the capability to deploy a lambda in PHP thanks to custom layers.

## example

```hcl
module "lambda-deployer" {
  source = "app.terraform.io/fulll/lambda/aws"
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

Lambda Functions from Container Image stored on AWS ECR

```hcl
module "lambda_function_container_image" {
  source = "app.terraform.io/fulll/lambda/aws"
  version = "~>10.133.0"

  function_name = "my-lambda-existing-package-local"
  description   = "My awesome lambda function"

  create_package = false

  image_uri    = "123456789123.dkr.ecr.eu-west-1.amazonaws.com/example:1.0"
  package_type = "Image"
}
```

## Required Inputs

These variables must be set in the `module` block when using this module.

### app_id **`string`**

Description: The id of the application

### app_name **`string`**

Description: The name of the application

### default_account_arn **`string`**

Description: The security account arn

### environment **`map(string)`**

Description: key value map of environment variables to give to the lambda

### lambda_bucket **`string`**

Description: the bucket containing the lambda function

### lambda_bucket_key **`string`**

Description: the path to the lambda.zip file

### lambda_cannonicalname **`string`**

Description: the name used in computation of the lambda name - <stage>-<app_name>-<cannonical_name>

### lambda_filepath **`string`**

Description: the path to the lambda.zip file

### lambda_handler **`string`**

Description: the handler called by the lambda

### lambda_logs_to_kibana_name **`string`**

Description: name of the lambda to log in kibana

### lambda_reserved_concurrent_executions **`number`**

Description: (no description specified)

### logs_to_kibana_subscription_filter_name **`string`**

Description: the kibana subscription filter name

### security_account_arn **`string`**

Description: The security account arn

### stage **`string`**

Description: The deploy environment in [prod, dev, preprod]

### vpc **`object({ subnet_ids = list(string) security_group_ids = list(string) })`**

Description: expected subnet_ids => [] and security_group_ids => []

## Optional Inputs

These variables have default values and don't have to be set to use this module. You may set these variables to override their default values.

### common_tags **`map(string)`**

Description: a list of tags set on the different resources

Default: `{}`

### enable_dead_letter_queue **`bool`**

Description: (no description specified)

Default: `false`

### enable_invocation **`bool`**

Description: whether the lambda is invocated after creation

Default: `false`

### lambda_layers **`list(string)`**

Description: the list of custom layers which can be used by the lambda

Default: `[]`

### lambda_max_retry **`number`**

Description: (Optional) Maximum number of times to retry when the function returns an error. Valid values between 0 and 2.

Default: `2`

### lambda_maximum_event_age_in_seconds **`number`**

Description: (Optional) Maximum age of a request that Lambda sends to a function for processing in seconds. Valid values between 60 and 21600.

Default: `60`

### lambda_memory_size **`number`**

Description: memory size

Default: `1024`

### lambda_publish **`bool`**

Description: whether the lambda is published or not

Default: `false`

### lambda_runtime **`string`**

Description: the runtime used by the lambda

Default: `"nodejs10.x"`

### lambda_timeout **`number`**

Description: the lambda timeout

Default: `60`

### secret_managers **`list(string)`**

Description: list of the secret manager the lambda can read

Default: `[]`

### image_uri **`string`**

Description: The ECR image URI containing the function's deployment package

Default: `Null`

## Output

### lambda_arn

Description: (no description specified)

### lambda_function_name

Description: (no description specified)

### lambda_invocation_result

Description: String result of Lambda execution

### lambda_role_name

Description: (no description specified)

### lambda_version

Description: (no description specified)

### sqs_dead_letter_queue_arn

Description: (no description specified)

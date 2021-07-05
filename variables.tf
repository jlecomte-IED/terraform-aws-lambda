variable "stage" {
  type        = string
  description = "The deploy environment in [prod, dev, preprod]"
}

variable "common_tags" {
  type        = map(string)
  description = "a list of tags set on the different resources"
  default     = {}
}

variable "app_id" {
  type        = string
  description = "The id of the application"
}

variable "app_name" {
  type        = string
  description = "The name of the application"
}

variable "vpc" {
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  description = "expected subnet_ids => [] and security_group_ids => []"
}

variable "security_account_arn" {
  type        = string
  description = "The security account arn"
}

variable "default_account_arn" {
  type        = string
  description = "The security account arn"
}

variable "lambda_filepath" {
  type        = string
  description = "the path to the lambda.zip file"
}

variable "lambda_cannonicalname" {
  type        = string
  description = "the name used in computation of the lambda name - <stage>-<app_name>-<cannonical_name>"
}

variable "lambda_handler" {
  type        = string
  description = "the handler called by the lambda"
}

variable "lambda_runtime" {
  type        = string
  description = "the runtime used by the lambda"
  default     = "nodejs10.x"
}

variable "lambda_layers" {
  type        = list(string)
  description = "the list of custom layers which can be used by the lambda"
  default     = []
}

variable "lambda_timeout" {
  type        = number
  description = "the lambda timeout"
  default     = 60
}

variable "lambda_memory_size" {
  type        = number
  description = "the lambda timeout"
  default     = 1024
}

variable "lambda_bucket" {
  type        = string
  description = "the bucket containing the lambda function"
}

variable "lambda_bucket_key" {
  type        = string
  description = "the path to the lambda.zip file"
}


variable "lambda_reserved_concurrent_executions" {
  type    = number
  default = null
}

variable "lambda_max_retry" {
  type    = number
  default = 2
}

variable "lambda_maximum_event_age_in_seconds" {
  type    = number
  default = 60
}

variable "lambda_publish" {
  type        = bool
  description = "whether the lambda is published or not"
  default     = false
}

variable "enable_invocation" {
  type        = bool
  default     = false
  description = "whether the lambda is invocated after creation"
}

variable "lambda_logs_to_kibana_name" {
  type        = string
  description = "name of the lambda to log in kibana"
}

variable "logs_to_kibana_subscription_filter_name" {
  type        = string
  description = "the kibana subscription filter name"
}


variable "secret_managers" {
  type        = list(string)
  description = "list of the secret manager the lambda can read"
  default     = []
}

variable "environment" {
  type        = map(string)
  description = "key value map of environment variables to give to the lambda"
}

variable "enable_dead_letter_queue" {
  type    = bool
  default = false
}

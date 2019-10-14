locals {
  camel_app_name = replace(title(replace(var.app_name, "/\\W+/", " ")), " ", "")

  lambda_role_name     = "${local.camel_app_name}${title(var.lambda_cannonicalname)}${title(var.stage)}"
  lambda_function_name = "${var.stage}-${var.app_name}-${lower(var.lambda_cannonicalname)}"
}

provider "aws" {
  region = var.region
}

resource "aws_iam_role" "mikes_lambda_pre_sign_up_role" {
  name               = "mikes_lambda_pre_sign_up_role"
  assume_role_policy = file("policy/lambda_assume_role_policy.json")
}

resource "aws_lambda_function" "mikes_lambda_pre_sign_up" {
  function_name = "mikes_lambda_pre_sign_up"
  handler       = "app/lambda_function.handler"
  runtime       = "python3.11"
  role          = aws_iam_role.mikes_lambda_pre_sign_up_role.arn

  filename = "lambda_function.zip"

  source_code_hash = filebase64sha256("lambda_function.zip")

  depends_on = [
    aws_iam_role.mikes_lambda_pre_sign_up_role
  ]
}
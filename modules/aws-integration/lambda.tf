resource "aws_lambda_function" "awscur_initializer" {
  architectures = ["x86_64"]
  ephemeral_storage {
    size = 512
  }

  function_name                  = "${var.cluster_name}-awscur-initializer"
  filename                       = "resources/awscur-initializer.zip"
  package_type                   = "Zip"
  memory_size                    = 128
  handler                        = "index.handler"
  timeout                        = 30
  runtime                        = "nodejs16.x"
  source_code_hash               = "EpOpP8Eir60NJ8Bq+haFR1gYUsAH+aDz7xZ4bFidot4="
  reserved_concurrent_executions = 1
  role                           = aws_iam_role.awscur_crawler_lambda_executor.arn
  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_permission" "awss3_cur_event_lambda_permission" {
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.awscur_initializer.arn
  principal      = "s3.amazonaws.com"
  source_account = var.aws.account_id
  source_arn     = "arn:${var.aws.partition}:s3:::${var.cluster_name}-us-east-1-cur-athena"
}

resource "aws_lambda_function" "awss3_cur_notification" {
  architectures = ["x86_64"]
  ephemeral_storage {
    size = 512
  }

  function_name                  = "${var.cluster_name}-awss3-cur-notification"
  filename                       = "resources/awss3-cur-notification.zip"
  package_type                   = "Zip"
  handler                        = "index.handler"
  timeout                        = 30
  runtime                        = "nodejs16.x"
  source_code_hash               = "Ba4M42hl3KStaz6k96Q3GWfLuQAqQN2XbL0ZlQ4gl0s="
  reserved_concurrent_executions = 1
  role                           = aws_iam_role.awss3_cur_lambda_executor.arn
  tracing_config {
    mode = "PassThrough"
  }
}
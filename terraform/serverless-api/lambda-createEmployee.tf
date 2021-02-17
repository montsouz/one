data "archive_file" "createEmployee" {
  type        = "zip"
  source_file = "${path.module}/create-employee.js"
  output_path = "${path.module}/create-employee.zip"
}

resource "aws_lambda_function" "createEmployee" {
  filename      = "${path.module}/create-employee.zip"
  function_name = "createEmployee"
  role          = aws_iam_role.this.arn
  handler       = "create-employee.create"

  source_code_hash = filebase64sha256(data.archive_file.createEmployee.output_path)

  runtime = "nodejs12.x"

  environment {
    variables = {
      DEBUG = "false"
    }
  }

  # in seconds
  timeout = 10

  tags = {
    Name = var.name
  }

  depends_on = [
  data.archive_file.createEmployee, aws_cloudwatch_log_group.createEmployee]

}

resource "aws_cloudwatch_log_group" "createEmployee" {
  name              = "/aws/lambda/createEmployee"
  retention_in_days = 14
}

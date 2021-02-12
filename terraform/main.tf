provider "aws" {
  region = "sa-east-1"
}


resource "aws_dynamodb_table" "employee_dynamodb_table" {
  name           = "employees-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "Id"

  attribute {
    name = "Id"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  tags = {
    Name        = "dynamodb-employees-table"
    Environment = "dev"
  }
}


resource "aws_ssm_parameter" "table_arn" {
  name        = "/database/${var.table_name}/table_arn"
  description = "Arn to acess ${var.table_name} resources"
  type        = "String"
  value       = aws_dynamodb_table.employee_dynamodb_table.arn
}


resource "aws_ssm_parameter" "table_id" {
  name        = "/database/${var.table_name}/id"
  description = "Get the table id"
  type        = "String"
  value       = aws_dynamodb_table.employee_dynamodb_table.id
}

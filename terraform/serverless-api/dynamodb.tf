resource "aws_dynamodb_table" "employees_terraform_dynamodb_table" {
  name           = "employees-terraform-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "Id"

  attribute {
    name = "Id"
    type = "S"
  }

}

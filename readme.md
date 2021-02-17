# One

A rest API built with Node, DynamoDB, Serverless, and Terraform.

Imagine the following case:

> Provision an infrastructure on AWS, in which there is a lambda that is capable of recording data on a company's employees in a relational or non-relational database.

## Why using Terraform and Serverless?

According to Sebastian Borza, a Software Engineer at Serverless.

> Terraform is best suited for managing more persistent shared infrastructure, while Serverless is a good fit to manage the application-specific infrastructure.

I considered the DyanamoDB database as a persistent infrastructure while Serverless manages the Lambda Functions

## Sharing data with SSM

In this case, Terraform shares data with Serverless using AWS SSM.

```
# main.tf

resource "aws_ssm_parameter" "table_arn" {
  name        = "/database/${var.table_name}/table_arn"
  description = "Arn to acess ${var.table_name} resources"
  type        = "String"
  value       = aws_dynamodb_table.employee_dynamodb_table.arn
}

```

We need the table ARN generated by Terraform to create the IAM role that is going to be used by the Lambda Functions

```yml
iamRoleStatements:
  - Effect: Allow
    Action:
      - dynamodb:Query
      - dynamodb:Scan
      - dynamodb:GetItem
      - dynamodb:PutItem
      - dynamodb:UpdateItem
      - dynamodb:DeleteItem
    Resource: ${ssm:/database/employees-table/table_arn~true}
```

## Limitation

Well, SSM is only available on AWS.

## Running the application

First, you need to run Terraform

```bash

cd terraform
terraform init
sh run.sh

```

It should create the DynamoDB database and store ARN and Table Name inside SSM.

Next, run Serverless

```bash

cd serverless
serverless deploy

```

And that's it!

## Employees API

| Field  | Description               |
| ------ | ------------------------- |
| **Id** | The employee's unique id. |
| Nome   | The employee's name.      |
| Cargo  | The employee's job        |
| Idade  | The employee's age        |

### Available Endpoints

- POST - /employees

- GET - /employees

- GET - /employees/{id}

- PUT - /employees/{id}

- DELETE - /employees/{id}

## Extra - Creating a lambda using only Terraform

You can check the code inside terraform/serverless-api

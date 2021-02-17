resource "aws_iam_role" "this" {
  name = var.name

  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = var.name
  }
}



data "aws_iam_policy_document" "this" {

  statement {
    actions = [
      "*"
    ]

    effect = "Allow"

    resources = [
      aws_dynamodb_table.employees_terraform_dynamodb_table.arn,
      "arn:aws:logs:*"
    ]

    sid = "codecommitid"
  }
}

resource "aws_iam_role_policy" "this" {
  policy = data.aws_iam_policy_document.this.json
  role   = aws_iam_role.this.id
}

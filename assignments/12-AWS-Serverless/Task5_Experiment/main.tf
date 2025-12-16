provider "aws" {
  region = "us-east-1"
}

# 1. Create a Serverless Database (DynamoDB)
resource "aws_dynamodb_table" "my_table" {
  name           = "Task5-Users-Table"
  billing_mode   = "PAY_PER_REQUEST" # Serverless mode (pay only for what you use)
  hash_key       = "UserId"

  attribute {
    name = "UserId"
    type = "S" # String
  }

  tags = {
    Environment = "Task5-Lab"
    ManagedBy   = "Terraform"
  }

}
# 2. Prepare the Python code for upload (Zip it)
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function.zip"
}

# 3. Create the IAM Role (Permission for Lambda to run)
resource "aws_iam_role" "lambda_exec_role" {
  name = "serverless_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# 4. Create the Lambda Function itself
resource "aws_lambda_function" "my_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "Task5-MyFirstLambda"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}
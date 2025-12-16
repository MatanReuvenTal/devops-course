provider "aws" {
  region = "us-east-1"
}

# --- 1. AWS Secrets Manager ---
# Create the secret container
resource "aws_secretsmanager_secret" "my_secret" {
  name = "MyTask5Secret"
  recovery_window_in_days = 0 # Force immediate deletion on destroy
}

# Store the actual secret value (password)
resource "aws_secretsmanager_secret_version" "my_secret_val" {
  secret_id     = aws_secretsmanager_secret.my_secret.id
  secret_string = "MySuperSecretPassword123!"
}

# --- 2. IAM Role & Policies ---
# Create an IAM Role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "task5_serverless_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# Attach a policy to allow reading the specific secret
resource "aws_iam_role_policy" "lambda_policy" {
  name = "task5_secret_access_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = "secretsmanager:GetSecretValue",
        Resource = aws_secretsmanager_secret.my_secret.arn
      },
      {
        Effect = "Allow",
        Action = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# --- 3. Lambda Function ---
# Automatically zip the Python code before deployment
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function.zip"
}

# Deploy the Lambda function
resource "aws_lambda_function" "my_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "Task5-Secrets-Api-Lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

# --- 4. API Gateway (HTTP API) ---
# Create the HTTP API
resource "aws_apigatewayv2_api" "http_api" {
  name          = "task5-api"
  protocol_type = "HTTP"
}

# Create a default stage with auto-deploy enabled
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

# Integrate the API Gateway with the Lambda function
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.my_lambda.invoke_arn
}

# Define the route (catch-all GET route)
resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Grant API Gateway permission to invoke the Lambda function
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

# --- 5. Output ---
# Display the public URL after deployment
output "website_url" {
  value = aws_apigatewayv2_stage.default.invoke_url
  description = "The public URL of the API Gateway"
}


resource "aws_iam_role" "lambda_exec" {
  name = "hailstone-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Automatically zip up your code
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/hailstone_lambda.zip"
  source_dir  = "${path.module}/../src"
  excludes    = ["terraform", ".terraform", "*.tf", "*.tfstate", "*.tfstate.*"]
}

resource "aws_lambda_function" "hailstone" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "hailstone_lambda"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "cloud_api.lambda_function.lambda_handler"
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)
  runtime          = "python3.12"
  timeout          = 10
}

resource "aws_apigatewayv2_api" "api" {
  name          = "hailstone-api"
  protocol_type = "HTTP"
}

resource "aws_lambda_permission" "api_gw" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hailstone.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.hailstone.arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /hailstone"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}

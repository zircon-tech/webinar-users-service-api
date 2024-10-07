resource "aws_iam_role" "codedeploy_role" {
  name = "codedeploy-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "codedeploy.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRoleForLambda"
}

resource "aws_iam_role_policy_attachment" "s3_readonly_policy_attachment" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Create CodeDeploy Application for Lambda
resource "aws_codedeploy_app" "lambda_app" {
  name        = "${var.project_name}-lambda-app"
  compute_platform = "Lambda"
}

# Create CodeDeploy Deployment Group for Lambda with Canary deployment
resource "aws_codedeploy_deployment_group" "lambda_deployment_group" {
  app_name              = aws_codedeploy_app.lambda_app.name
  deployment_group_name = "lambda-deployment-group"
  service_role_arn      = aws_iam_role.codedeploy_role.arn

  deployment_config_name = "CodeDeployDefault.LambdaCanary10Percent5Minutes"  # Canary deployment strategy

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  alarm_configuration {
    enabled = false  # Optional: Set to true and configure CloudWatch alarms if needed
  }

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }
}

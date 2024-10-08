resource "aws_lambda_function" "service_function" {
    function_name = "${var.project_name}-function"
    role          = aws_iam_role.lambda_exec_role.arn
    package_type  = "Image"  # Specify that the Lambda function uses a Docker image
    image_uri     = "${aws_ecr_repository.ecr_repo.repository_url}:latest"  # Use the Docker image from ECR

    timeout       = 60
    memory_size   = 512
    publish       = true

    environment {
        variables = {
            STAGE = "prod"
        }
    }
}

resource "aws_lambda_alias" "prod_alias" {
    name             = "prod"
    function_name    = aws_lambda_function.service_function.function_name
    function_version = "1"

    # To use CodeDeploy, ignore change of function_version
    lifecycle {
        ignore_changes = [function_version, routing_config]
    }
}

# Lambda Execution Role
resource "aws_iam_role" "lambda_exec_role" {
    name = "lambda_exec_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
            Action    = "sts:AssumeRole",
            Effect    = "Allow",
            Principal = {
                Service = "lambda.amazonaws.com"
            }
        }]
    })
}

resource "aws_iam_role_policy" "ecr_access_policy" {
    name = "ecr_access_policy"
    role = aws_iam_role.lambda_exec_role.id

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Action = [
                    "ecr:GetDownloadUrlForLayer",
                    "ecr:BatchGetImage",
                    "ecr:BatchCheckLayerAvailability"
                ],
                Resource = "*"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
    role       = aws_iam_role.lambda_exec_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

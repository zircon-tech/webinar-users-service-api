# AppRunner Service
resource "aws_apprunner_service" "app_runner_service" {
  service_name = "${var.project_name}-apprunner"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_ecr_access_role.arn
    }

    image_repository {
      image_identifier      = "${aws_ecr_repository.ecr_repo.repository_url}:latest"
      image_configuration {
        port = "8080"
      }
      image_repository_type = "ECR"
    }
  }

  instance_configuration {
    cpu    = "1024"
    memory = "2048"
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.autoscaling.arn
}

# IAM Role to allow AppRunner to pull images from ECR
resource "aws_iam_role" "apprunner_ecr_access_role" {
  name = "${var.project_name}-apprunner-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "build.apprunner.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "apprunner_ecr_access_policy" {
  role       = aws_iam_role.apprunner_ecr_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Auto-scaling configuration for AppRunner
resource "aws_apprunner_auto_scaling_configuration_version" "autoscaling" {
  auto_scaling_configuration_name = "example"

  max_concurrency = 50
  max_size        = 5
  min_size        = 1
}

# Output the AppRunner Service URL
output "apprunner_service_url" {
  value       = aws_apprunner_service.app_runner_service.service_url
  description = "The URL of the AppRunner service"
}

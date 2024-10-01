# IAM Role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "${var.project_name}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
    }]
  })
}

# IAM Policy for CodeBuild (Allow pushing to ECR)
resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "${var.project_name}-codebuild-policy"
  role   = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
            "ecr:GetAuthorizationToken"
        ]
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Effect   = "Allow"
        Resource = aws_ecr_repository.ecr_repo.arn
      },
      {
        Action = "logs:*",
        Effect = "Allow",
        Resource = "*"
      },
    ]
  })
}

# CodeBuild Project
resource "aws_codebuild_project" "codebuild" {
  name = var.project_name
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type      = "GITHUB"
    location  = var.github_repo_url
  }

  environment {
    compute_type              = "BUILD_GENERAL1_SMALL"
    image                     = "aws/codebuild/standard:5.0"
    type                      = "LINUX_CONTAINER"
    privileged_mode           = true

    environment_variable {
      name  = "REPOSITORY_URI"
      value = aws_ecr_repository.ecr_repo.repository_url
    }
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  build_timeout = 30
}

resource "aws_codebuild_source_credential" "app" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.github_oauth_token
}

resource "aws_codebuild_webhook" "app" {
  project_name = aws_codebuild_project.codebuild.name
  build_type   = "BUILD"
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "main"
    }
  }
}

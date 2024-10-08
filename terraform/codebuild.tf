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
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:PutObjectVersionAcl",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = "lambda:*",
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = "logs:*",
        Effect = "Allow",
        Resource = "*"
      },
    ]
  })
}

# Build CodeBuild Project
resource "aws_codebuild_project" "build_project" {
  name          = "${var.project_name}-build"
  service_role  = aws_iam_role.codebuild_role.arn
  source {
    type      = "CODEPIPELINE"
    buildspec = file("build/buildspec.build.yml")
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"
  }
}

# Test CodeBuild Project
resource "aws_codebuild_project" "test_project" {
  name          = "${var.project_name}-test"
  service_role  = aws_iam_role.codebuild_role.arn
  source {
    type      = "CODEPIPELINE"
    buildspec = file("build/buildspec.test.yml")
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"
  }
}

output "codebuild_project_names" {
  description = "The names of the CodeBuild projects"
  value = {
    build_project   = aws_codebuild_project.build_project.name
    test_project    = aws_codebuild_project.test_project.name
  }
}

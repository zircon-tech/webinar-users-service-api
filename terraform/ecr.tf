# ECR Repository
resource "aws_ecr_repository" "ecr_repo" {
  name = var.ecr_repository_name
}


# ECR Repository
resource "aws_ecr_repository" "ecr_repo" {
  name = var.ecr_repository_name
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.ecr_repo.repository_url
}

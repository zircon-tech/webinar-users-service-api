output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.ecr_repo.repository_url
}

output "codebuild_project_name" {
  description = "The name of the CodeBuild project"
  value       = aws_codebuild_project.codebuild.name
}

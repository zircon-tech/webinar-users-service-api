variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-2"
}

variable "github_repo_url" {
  description = "GitHub Repository URL to pull source code from"
  type        = string
}

variable "github_oauth_token" {
  description = "GitHub OAuth token for authentication"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Name of the CodeBuild project and ECR repository"
  type        = string
  default     = "my-app"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "my-app-ecr"
}

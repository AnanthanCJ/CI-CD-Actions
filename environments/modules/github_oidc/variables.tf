variable "github_repo" {
  description = "GitHub repo allowed to assume the CI role, as org/repo"
  type        = string
}

variable "github_branch" {
  description = "Branch allowed to assume the CI role for deploy-affecting workflows"
  type        = string
  default     = "main"
}

variable "role_name" {
  description = "Name of the IAM role GitHub Actions assumes via OIDC"
  type        = string
  default     = "github-actions-ci"
}

variable "ecr_repository_arns" {
  description = "ECR repository ARNs this role may push to"
  type        = list(string)
}

variable "create_oidc_provider" {
  description = "Whether to create the GitHub OIDC provider. Set false if one already exists in this AWS account."
  type        = bool
  default     = true
}

variable "github_environment" {
  description = "GitHub environment allowed to assume the CI role for deploy-affecting workflows"
  type        = string
  default     = "dev"
}
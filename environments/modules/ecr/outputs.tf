output "repository_url" {
  description = "ECR repository URL, used to tag and push images"
  value       = aws_ecr_repository.app.repository_url
}

output "repository_arn" {
  description = "ECR repository ARN, used to scope IAM policies"
  value       = aws_ecr_repository.app.arn
}

output "repository_name" {
  description = "ECR repository name"
  value       = aws_ecr_repository.app.name
}

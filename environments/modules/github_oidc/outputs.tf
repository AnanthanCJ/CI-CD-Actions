output "role_arn" {
  description = "Role ARN for the AWS credentials step in the GitHub Actions workflow"
  value       = aws_iam_role.ci.arn
}

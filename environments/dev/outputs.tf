output "public_ips" {
    description = "public ips for ec2 instances"
    value = module.ec2.instance_ips
}

output "ecr_repository_url" {
    description = "ECR repository URL for the sample app image"
    value = module.ecr.repository_url
}

output "github_actions_role_arn" {
    description = "Role ARN for the AWS credentials step in the GitHub Actions workflow"
    value = module.github_oidc.role_arn
}
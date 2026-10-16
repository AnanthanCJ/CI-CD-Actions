module "vpc" {
    source = "../modules/vpc"
    vpc_cidr = var.vpc_cidr
    subnet_cidr = var.subnet_cidr
    availability_zone = var.availability_zone
}

module "ec2" {
    source = "../modules/ec2"
    vpc_id = module.vpc.vpc_id
    ami_id = var.ami_id
    instance_type = var.instance_type
    subnet_id = module.vpc.subnet_id
    allowed_cidr_blocks = var.allowed_cidr_blocks
    existing_key_name = var.existing_key_name
    public_key_path = var.public_key_path
    instance_count = var.instance_count

    depends_on = [module.vpc]
}

module "ecr" {
    source = "../modules/ecr"
    repository_name = var.ecr_repository_name
}

module "github_oidc" {
    source = "../modules/github_oidc"
    github_repo = var.github_repo
    github_branch = var.github_branch
    ecr_repository_arns = [module.ecr.repository_arn]
}
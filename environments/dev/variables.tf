variable "vpc_cidr" {
  description = "vpc cidr"
  type = string
}

variable "subnet_cidr" {
  description = "subnet cidr"
  type =  string
}

variable "availability_zone" {
  description = "availability zone"
  type = string
}

variable "ami_id" {
  description = "ami id"
  type = string
}

variable "instance_type" {
  description = "instance type"
  type = string
}

variable "allowed_cidr_blocks" {
  description = "allowed cidr blocks"
  type = list(string)
}

variable "existing_key_name" {
  description = "Name of an existing EC2 key pair to use. Leave null to create a new one from public_key_path"
  type = string
  default = null
}

variable "public_key_path" {
  description = "Local SSH public key to register as a new EC2 key pair (used when existing_key_name is null)"
  type = string
  default = null
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type = number
  default = 1
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository for the app image"
  type = string
  default = "ci-cd-sample-app"
}

variable "github_repo" {
  description = "GitHub repo allowed to assume the CI role, as org/repo"
  type = string
  default = "AnanthanCJ/CI-CD-Actions"
}

variable "github_branch" {
  description = "Branch allowed to assume the CI role for deploy-affecting workflows"
  type = string
  default = "main"
}
variable "github_environment" {
  description = "environment name"
  type = string
  default = "dev"
}
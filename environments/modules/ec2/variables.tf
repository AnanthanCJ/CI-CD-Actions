variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "public subnet id"
  type = string
}

variable "vpc_id" {
  description = "vpc id"
  type = string
}

variable "allowed_cidr_blocks" {
  description = "allowed cidr block for ingress"
  type = list(string)
}

variable "existing_key_name" {
  description = "Name of an existing EC2 key pair to use. Leave null to create a new key pair from public_key_path"
  type        = string
  default     = null
}

variable "public_key_path" {
  description = "Path to a local SSH public key to register as a new EC2 key pair. Only used when existing_key_name is null"
  type        = string
  default     = null
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}
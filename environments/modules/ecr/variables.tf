variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "IMMUTABLE or MUTABLE"
  type        = string
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  description = "Scan images for vulnerabilities on push"
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "Allow deleting the repository even if it still has images"
  type        = bool
  default     = true
}

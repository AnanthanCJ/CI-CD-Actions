moved {
  from = aws_ecr_repository.app
  to   = module.ecr.aws_ecr_repository.app
}

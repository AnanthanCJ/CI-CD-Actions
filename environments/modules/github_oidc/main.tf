# GitHub's OIDC issuer is one-per-AWS-account. If this module is used in
# more than one environment against the same account, set
# create_oidc_provider = false in every environment after the first, and
# the data source below picks up the one that already exists.
resource "aws_iam_openid_connect_provider" "github" {
  count = var.create_oidc_provider ? 1 : 0

  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd",
  ]
}

data "aws_iam_openid_connect_provider" "github" {
  count = var.create_oidc_provider ? 0 : 1
  url   = "https://token.actions.githubusercontent.com"
}

locals {
  oidc_provider_arn = var.create_oidc_provider ? aws_iam_openid_connect_provider.github[0].arn : data.aws_iam_openid_connect_provider.github[0].arn
}

data "aws_iam_policy_document" "trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Only workflow runs triggered on this exact branch of this exact repo
    # may assume the role. Adjust to allow tags or other branches if needed.
    #
    # StringLike (not StringEquals) because GitHub appends an immutable
    # "@<org-id>"/"@<repo-id>" suffix to the org and repo names in the sub
    # claim if the org or repo has ever been renamed/transferred, e.g.
    # "repo:AnanthanCJ@152945570/CI-CD-Actions@1422459425:environment:dev".
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${split("/", var.github_repo)[0]}*/${split("/", var.github_repo)[1]}*:environment:${var.github_environment}"]
    }
  }
}

resource "aws_iam_role" "ci" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

# Only what the pipeline needs: push images to the given ECR repositories.
data "aws_iam_policy_document" "ecr_push" {
  statement {
    sid       = "AuthToken"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "PushPullTheseRepos"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
    ]
    resources = var.ecr_repository_arns
  }
}

resource "aws_iam_role_policy" "ecr_push" {
  name   = "ecr-push"
  role   = aws_iam_role.ci.id
  policy = data.aws_iam_policy_document.ecr_push.json
}

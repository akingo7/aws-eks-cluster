resource "aws_iam_role_policy" "policy" {
  name   = "${var.name}_policy"
  role   = aws_iam_role.role.id
  policy = var.policy_file_path
}

resource "aws_iam_role" "role" {
  name               = "${var.name}_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.eks_oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${var.eks_oidc_provider}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "${var.eks_oidc_provider}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
    }
  }
}

resource "kubernetes_service_account" "service_account" {
  count = var.create_kube_service_account ? 1 : 0
  metadata {
    name      = var.service_account_name
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.role.arn
    }
  }
}

#### Locals ####
locals {
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 3)
}

resource "aws_iam_role_policy" "alb_controller_policy" {
  name   = "alb_controller_policy"
  role   = aws_iam_role.alb_controller_role.id
  policy = file("template/alb-iam-policy.json")
}

resource "aws_iam_role" "alb_controller_role" {
  name               = "alb_controller_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "kubernetes_service_account" "alb_controller_service_account" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller_role.arn
    }
  }
}



resource "helm_release" "alb_controller" {
  name       = "alb-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "eks"
  version    = "6.0.1"

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.alb_controller_service_account.default_secret_name
  }
}

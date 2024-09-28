
#### Locals ####
locals {
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 3)
}


######## Remember: All IAM policies can be modified to enhance their security. ########
# #### ALB Controller Resources ####

# module "alb_controller" {
#   source                      = "./modules/irsa"
#   name                        = "alb_controller"
#   policy_file_path            = file("template/alb-iam-policy.json")
#   eks_oidc_provider_arn       = module.eks.oidc_provider_arn
#   eks_oidc_provider           = module.eks.oidc_provider
#   namespace                   = "kube-system"
#   service_account_name        = "aws-load-balancer-controller"
#   create_kube_service_account = true

# }


# resource "helm_release" "alb_controller" {
#   name       = "alb-load-balancer-controller"
#   verify     = false
#   repository = "https://aws.github.io/eks-charts"
#   namespace  = "kube-system"
#   chart      = "aws-load-balancer-controller"
#   version    = "1.8.3"

#   set {
#     name  = "clusterName"
#     value = module.eks.cluster_name
#   }

#   set {
#     name  = "serviceAccount.create"
#     value = "false"
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }
#   depends_on = [module.alb_controller]
# }

#### Nginx Load Balancer Controller Resources ####

module "nginx_controller" {
  source                      = "./modules/irsa"
  name                        = "nginx_load_balancer_controller"
  policy_file_path            = file("template/load-balancer-controller-iam-policy.json")
  eks_oidc_provider_arn       = module.eks.oidc_provider_arn
  eks_oidc_provider           = module.eks.oidc_provider
  namespace                   = "ingress-nginx"
  service_account_name        = "nginx-controller"
  create_kube_service_account = true
}


resource "helm_release" "nginx_controller" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  namespace        = "ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.11.2"
  create_namespace = true

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = module.nginx_controller.service_account_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.nginx_controller.role_arn
  }

  depends_on = [module.nginx_controller]
}


#### Cert Manager Service Account Role ####

module "cert_manager" {
  source                      = "./modules/irsa"
  name                        = "cert_manager"
  policy_file_path            = file("template/cert-manager-policy.json")
  eks_oidc_provider_arn       = module.eks.oidc_provider_arn
  eks_oidc_provider           = module.eks.oidc_provider
  namespace                   = "cert-manager"
  service_account_name        = "cert-manager"
  create_kube_service_account = false
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  verify           = false
  repository       = "https://charts.jetstack.io"
  namespace        = "cert-manager"
  chart            = "cert-manager"
  version          = "1.15.3"
  create_namespace = true

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.cert_manager.role_arn
  }

  set {
    name  = "crds.enabled"
    value = "true"
  }

  set {
    name  = "securityContext.fsGroup"
    value = "1001"
  }
  depends_on = [module.cert_manager]
}
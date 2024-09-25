output "eks_cluster_name" {
    value = module.eks.cluster_name
}

output "eks_cluster_region" {
    value = module.eks.cluster_oidc_issuer_url
}
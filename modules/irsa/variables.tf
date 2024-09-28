variable "name" {
  type = string
}

variable "policy_file_path" {
  type = any
}
variable "eks_oidc_provider" {
  type = string
}
variable "eks_oidc_provider_arn" {
  type = string
}
variable "namespace" {
  type = string
}
variable "service_account_name" {
  type = string
}

variable "create_kube_service_account" {
  type = bool
}





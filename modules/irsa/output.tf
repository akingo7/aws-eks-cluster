output "role_arn" {
  value = aws_iam_role.role.arn
}

output "service_account_name" {
  value = var.service_account_name
}
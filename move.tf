moved {
  from = aws_iam_policy_document.assume_role
  to = module.alb_controller.aws_iam_policy_document.assume_role
}

moved {
  from = aws_iam_role.alb_controller_role
  to = module.alb_controller.aws_iam_role.role
}

moved {
  from = aws_iam_role_policy.alb_controller_policy
  to = module.alb_controller.aws_iam_role_policy.policy
}

moved {
  from = kubernetes_service_account.alb_controller_service_account
  to = module.alb_controller.kubernetes_service_account.service_account[0]
}

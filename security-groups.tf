module "eks_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.organisation}-test-service"
  description = "Security group for test-service with custom ports open within VPC, and PostgreSQL publicly open"
  create      = false
  vpc_id      = module.vpc.default_vpc_id

  ingress_cidr_blocks = ["10.10.0.0/16"]
  ingress_rules       = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8090
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "10.10.0.0/16"
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.organisation}-vpc"
  cidr = var.vpc_cidr

  azs             = local.availability_zones
  private_subnets = [for x in range(var.private_subnets_count) : cidrsubnet(var.vpc_cidr, 8, x)]
  public_subnets  = [for x in range(var.public_subnets_count) : cidrsubnet(var.vpc_cidr, 8, 10 + x)]

  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway
  map_public_ip_on_launch = var.map_public_ip_on_launch


  tags = merge(var.tags)
}
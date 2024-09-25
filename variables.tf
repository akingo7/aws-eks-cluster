#### Data Sources ####
data "aws_availability_zones" "available" {
  state = "available"
}

#### Variables ####
variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "organisation" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "enable_nat_gateway" {
  type    = string
  default = true
}

variable "enable_vpn_gateway" {
  type    = string
  default = true
}

variable "map_public_ip_on_launch" {
  type    = string
  default = true
}

variable "public_subnets_count" {
  type    = number
  default = 3
}

variable "private_subnets_count" {
  type    = number
  default = 3
}


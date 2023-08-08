provider "aws" {
  region = "us-east-1"
}

locals {
  name        = "simple-connect-endpoint"
  description = "Managed by Terraform"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name            = local.name
  cidr            = "10.0.0.0/20"
  azs             = ["us-east-1a"]
  public_subnets  = ["10.0.0.0/24"]
  private_subnets = ["10.0.8.0/24"]

  manage_default_security_group = false
  manage_default_network_acl    = false
  enable_nat_gateway            = true
  single_nat_gateway            = true
  one_nat_gateway_per_az        = false
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = local.name
  vpc_id      = module.vpc.vpc_id
  description = local.description

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = local.description
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = "0.0.0.0/0"
      description = local.description
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
      description = local.description
    }
  ]
}

resource "aws_key_pair" "this" {
  key_name   = local.name
  public_key = fileexists(var.public_key) ? file(pathexpand(var.public_key)) : var.public_key
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  name                        = local.name
  instance_type               = "t2.micro"
  monitoring                  = false
  associate_public_ip_address = false
  key_name                    = aws_key_pair.this.key_name
  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [module.security_group.security_group_id]
}

module "ec2_connect_endpoint" {
  source = "../.."

  name               = local.name
  subnet_id          = module.vpc.private_subnets[0]
  security_group_ids = [module.security_group.security_group_id]
}

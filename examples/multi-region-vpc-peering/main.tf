provider "aws" {
  region = "us-east-1"
  alias  = "us"
}

provider "aws" {
  region = "eu-west-1"
  alias  = "eu"
}

locals {
  name        = "connect-endpoint"
  description = "Managed by Terraform"

  name_us = "${local.name}-us"
  name_eu = "${local.name}-eu"

  ec2_us = [
    {
      name      = "${local.name_us}-public1"
      subnet_id = module.vpc_us.public_subnets[0]
    },
    {
      name      = "${local.name_us}-private1"
      subnet_id = module.vpc_us.private_subnets[0]
    },
    {
      name      = "${local.name_us}-private2"
      subnet_id = module.vpc_us.private_subnets[1]
    },
  ]

  ec2_eu = [
    {
      name      = "${local.name_eu}-public1"
      subnet_id = module.vpc_eu.public_subnets[0]
    },
    {
      name      = "${local.name_eu}-private1"
      subnet_id = module.vpc_eu.private_subnets[0]
    },
  ]
}

module "vpc_us" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  providers = { aws = aws.us }

  name            = local.name_us
  cidr            = "10.1.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = ["10.1.0.0/21", "10.1.16.0/21", "10.1.32.0/21"]
  private_subnets = ["10.1.128.0/21", "10.1.144.0/21", "10.1.160.0/21"]

  manage_default_security_group = false
  manage_default_network_acl    = false
  enable_nat_gateway            = false
}

module "vpc_eu" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  providers = { aws = aws.eu }

  name            = local.name_eu
  cidr            = "10.2.0.0/16"
  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  public_subnets  = ["10.2.0.0/21", "10.2.16.0/21", "10.2.32.0/21"]
  private_subnets = ["10.2.128.0/21", "10.2.144.0/21", "10.2.160.0/21"]

  manage_default_security_group = false
  manage_default_network_acl    = false
  enable_nat_gateway            = false
}

module "vpc_peering" {
  source  = "grem11n/vpc-peering/aws"
  version = "6.0.0"

  providers = {
    aws.this = aws.us
    aws.peer = aws.eu
  }

  this_vpc_id  = module.vpc_us.vpc_id
  peer_vpc_id  = module.vpc_eu.vpc_id
  this_rts_ids = concat(module.vpc_us.public_route_table_ids, module.vpc_us.private_route_table_ids)
  peer_rts_ids = concat(module.vpc_eu.public_route_table_ids, module.vpc_eu.private_route_table_ids)

  auto_accept_peering = true
}

module "key_pair_us" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "2.0.2"

  providers = { aws = aws.us }

  key_name   = local.name_us
  public_key = fileexists(var.public_key) ? file(pathexpand(var.public_key)) : var.public_key
}

module "key_pair_eu" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "2.0.2"

  providers = { aws = aws.eu }

  key_name   = local.name_eu
  public_key = fileexists(var.public_key) ? file(pathexpand(var.public_key)) : var.public_key
}

module "security_group_us" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  providers = { aws = aws.us }

  name        = local.name_us
  vpc_id      = module.vpc_us.vpc_id
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

module "security_group_eu" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  providers = { aws = aws.eu }

  name        = local.name_eu
  vpc_id      = module.vpc_eu.vpc_id
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

module "ec2_instance_us" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  providers = { aws = aws.us }

  for_each = { for index, vm in local.ec2_us : vm.name => vm }

  name                        = each.value.name
  instance_type               = "t2.micro"
  monitoring                  = false
  associate_public_ip_address = false
  key_name                    = module.key_pair_us.key_pair_name
  subnet_id                   = each.value.subnet_id
  vpc_security_group_ids      = [module.security_group_us.security_group_id]
}

module "ec2_instance_eu" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  providers = { aws = aws.eu }

  for_each = { for index, vm in local.ec2_eu : vm.name => vm }

  name                        = each.value.name
  instance_type               = "t2.micro"
  monitoring                  = false
  associate_public_ip_address = false
  key_name                    = module.key_pair_eu.key_pair_name
  subnet_id                   = each.value.subnet_id
  vpc_security_group_ids      = [module.security_group_eu.security_group_id]
}

module "ec2_connect_endpoint_us" {
  source = "../.."

  providers = { aws = aws.us }

  name               = local.name_us
  subnet_id          = module.vpc_us.private_subnets[0]
  security_group_ids = [module.security_group_us.security_group_id]
}

module "ec2_connect_endpoint_eu" {
  source = "../.."

  providers = { aws = aws.eu }

  name               = local.name_eu
  subnet_id          = module.vpc_eu.private_subnets[0]
  security_group_ids = [module.security_group_eu.security_group_id]
}

# Terraform AWS EC2 Instance Connect Endpoint use case

This is a more advanced example, which shows not only how to use EC2 Instance Connect Endpoint, but also how to set up a multi-region VPC peering:

* [vpc module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
* [security-group module](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest)
* [vpc-peering module](https://registry.terraform.io/modules/grem11n/vpc-peering/aws/latest)
* [ec2-instance module](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest)
* [key-pair module](https://registry.terraform.io/modules/terraform-aws-modules/key-pair/aws/latest)

## Usage

```bash
terraform init
terraform apply
```

As the outputs, you get among others an aws cli commands to connect to your EC2 instances, for example:

```bash
...
...
vpc_us_instances = {
  "ec2_us_pub1" = {
    "cmd" = "aws --region us-east-1 ec2-instance-connect ssh --instance-id i-0123456789"
    "ip" = "10.1.1.2
  }
  "ec2_us_priv1" = {
    "cmd" = "aws --region us-east-1 ec2-instance-connect ssh --instance-id i-1123456789"
    "ip" = "10.1.1.3"
  }
  "ec2_us_priv2" = {
    "cmd" = "aws --region us-east-1 ec2-instance-connect ssh --instance-id i-2123456789"
    "ip" = "10.1.1.4"
  }
}
...
vpc_eu_instances = {
  "ec2_eu_priv1" = {
    "cmd" = "aws --region eu-west-1 ec2-instance-connect ssh --instance-id i-x123456789
    "ip" = "10.2.1.2"
  }
  "ec2_eu_pub1" = {
    "cmd" = "aws --region eu-west-1 ec2-instance-connect ssh --instance-id i-y123456789
    "ip" = "10.2.1.3"
  }
}
```

EC2 instances are set up in both VPCs, in public and private subnets. They have no public IP addresses, and none of them can connect to services outside your VPC (there's no NAT gateway).

To test out _EC2 Instance Connect Endpoint_ service, simply log in to any of those instances using a cmd command from the output.

To test out _VPC Peering_, simply ping instances in one VPC from another.

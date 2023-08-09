# Simple Terraform AWS EC2 Instance Connect Endpoint use case

This example uses also other resources necessary to connect to an EC2 instance without a public IP address:

* [vpc module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
* [security-group module](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest)
* [ec2-instance module](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest)
* [aws_key_pair resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)

## Usage

```bash
terraform init
terraform apply
```

As the output, you get an aws cli command to connect to your EC2 instance, for example:

```bash
cmd = "aws --region us-east-1 ec2-instance-connect ssh --instance-id i-0123456789"
```

The EC2 instance is set up in a private subnet, and, thanks to a NAT gateway, can connect to services outside your VPC.

# Terraform AWS EC2 Instance Connect Endpoint module

Terraform AWS module which manages an EC2 Instance Connect Endpoint.

EC2 Instance Connect Endpoint allows you to connect to an instance without requiring the instance to have a public IPv4 address. You can connect to any instances that support TCP.

## Usage

```hcl
module "ec2-connect-endpoint" {
  source = "git@github.com:uridium/terraform-aws-ec2-connect-endpoint.git"

  name               = "connect-endpoint"
  subnet_id          = "subnet-0123456789"
  security_group_ids = ["sg-0123456789"]
}
```

### Notes

* Only ports 22 and 3389 are supported.

* EC2 Instance Connect Endpoint doesn't support connections to an instance using IPv6 addresses.

* When client IP preservation is enabled, the instance to connect to must be in the same VPC as the EC2 Instance Connect Endpoint.

* Client IP preservation is not supported when traffic is routed through an AWS Transit Gateway.

* The following instance types do not support client IP preservation: C1, CG1, CG2, G1, G2, HI1, M1, M2, M3, and T1. If you are using these instance types, set the preserveClientIp parameter to false, otherwise attempting to connect to these instance types using EC2 Instance Connect Endpoint will fail.

For more information click [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connect-linux-inst-eic-Endpoint.html)

## Development

This module uses [pre-commit](https://pre-commit.com/) hook to identify simple issues before pushing code to the remote repository, and to generate documentation.

To install it, simply run:

```bash
pip install pre-commit
pre-commit install
```

Now `pre-commit` will run automatically on every `git commit`. You can also run it manually:

```bash
pre-commit run -av
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_instance_connect_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_instance_connect_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name to be used as a tag | `string` | n/a | yes |
| <a name="input_preserve_client_ip"></a> [preserve\_client\_ip](#input\_preserve\_client\_ip) | Indicates whether your client's IP address is preserved as the source | `bool` | `true` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | One or more security groups to associate with the endpoint | `list(string)` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet in which to create the EC2 Instance Connect Endpoint | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_zone"></a> [availability\_zone](#output\_availability\_zone) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_network_interface_ids"></a> [network\_interface\_ids](#output\_network\_interface\_ids) | n/a |
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | n/a |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

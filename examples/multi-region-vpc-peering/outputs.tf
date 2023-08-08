output "vpc_us_endpoint_id" {
  description = "The ID of the US EC2 Connect Endpoint"
  value       = module.ec2_connect_endpoint_us.id
}

output "vpc_eu_endpoint_id" {
  description = "The ID of the EU EC2 Connect Endpoint"
  value       = module.ec2_connect_endpoint_eu.id
}

output "vpc_us_instances" {
  description = "The list of EC2 instances in the US VPC"
  value = {
    for ec2_name, ec2_details in module.ec2_instance_us :
    ec2_name => {
      ip  = ec2_details.private_ip
      cmd = "aws --region ${split(":", ec2_details.arn)[3]} ec2-instance-connect ssh --instance-id ${split("/", ec2_details.arn)[1]}"
    }
  }
}

output "vpc_eu_instances" {
  description = "The list of EC2 instances in the EU VPC"
  value = {
    for ec2_name, ec2_details in module.ec2_instance_eu :
    ec2_name => {
      ip  = ec2_details.private_ip
      cmd = "aws --region ${split(":", ec2_details.arn)[3]} ec2-instance-connect ssh --instance-id ${split("/", ec2_details.arn)[1]}"
    }
  }
}

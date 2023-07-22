output "id" {
  value = aws_ec2_instance_connect_endpoint.this.id
}

output "subnet_id" {
  value = aws_ec2_instance_connect_endpoint.this.subnet_id
}

output "security_group_ids" {
  value = aws_ec2_instance_connect_endpoint.this.security_group_ids
}

output "availability_zone" {
  value = aws_ec2_instance_connect_endpoint.this.availability_zone
}

output "network_interface_ids" {
  value = aws_ec2_instance_connect_endpoint.this.network_interface_ids
}

output "vpc_id" {
  value = aws_ec2_instance_connect_endpoint.this.vpc_id
}

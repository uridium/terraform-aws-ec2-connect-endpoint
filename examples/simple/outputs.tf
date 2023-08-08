output "cmd" {
  description = "The AWS cli command to connect to your EC2 instance through the connect point"
  value       = "aws --region ${split(":", module.ec2_instance.arn)[3]} ec2-instance-connect ssh --instance-id ${split("/", module.ec2_instance.arn)[1]}"
}

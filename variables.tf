variable "subnet_id" {
  description = "The ID of the subnet in which to create the EC2 Instance Connect Endpoint"
  type        = string
}

variable "security_group_ids" {
  description = "One or more security groups to associate with the endpoint"
  type        = list(string)
  default     = null
}

variable "preserve_client_ip" {
  description = "Indicates whether your client's IP address is preserved as the source"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Map of tags to assign to this resource"
  type        = map(string)
  default     = null
}

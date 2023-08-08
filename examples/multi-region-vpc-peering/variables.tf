variable "public_key" {
  type        = string
  description = <<-EOF
    The public key material

    It can be either a string:
      public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6t..."
    or a path to the file:
      public_key = "~/.ssh/id_ed25519.pub"
  EOF
}

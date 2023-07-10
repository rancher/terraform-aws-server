
variable "owner" {
  description = <<-EOT
    The owner to tag resources with.
    If you are using the "id" field then this field is ignored.
  EOT
}

variable "name" {
  description = <<-EOT
    The name to give the server.
    If you are using the "id" field then this field is ignored.
  EOT
}

variable "user" {
  description = <<-EOT
    The user to install on the server, it will have sudo access.
    If you are using the "id" field then this field is ignored.
  EOT
}

variable "type" {
  description = <<-EOT
    The designation from types.tf of the EC2 instance type to use.
    If you are using the "id" field then this field is ignored.
  EOT
}

variable "image_id" {
  description = <<-EOT
    The id of the AMI to use.
    If you are using the "id" field then this field is ignored.
  EOT
}

variable "image_initial_user" {
  description = <<-EOT
    The initial or default user on the AMI.
    If you are using the "id" field then this field is ignored.
  EOT
}

variable "image_admin_group" {
  description = <<-EOT
    The group defined as an 'admin' on the AMI.
    If you are using the "id" field then this field is ignored.
  EOT
}

variable "ssh_key" {
  description = <<-EOT
    The contents of the public key to add to the server for ssh access.
    If you are using the "id" field then this field is ignored.
  EOT
}

variable "security_group" {
  description = <<-EOT
    The name of the security group which already exists in AWS to apply to the server.
    WARNING: Security groups are region specific, so if you are using this module in multiple regions, you will need to create a security group in each region.
    It is helpful to use the same name for security groups across regions.
    If you would like help accomplishing this, see the terraform-aws-access module that we produce.
    If you are using the "id" field then this field is ignored.
  EOT
}

variable "subnet" {
  description = <<-EOT
    The name of the subnet which already exists in AWS to provision the server on.
    WARNING: Subnets are region specific, so if you are using this module in multiple regions, you will need to create a subnet in each region.
    It is helpful to use the same name for subnets across regions.
    If you would like help accomplishing this, see the terraform-aws-access module that we produce.
    If you are using the "id" field then this field is ignored.
  EOT
}

variable "id" {
  description = <<-EOT
    The id of a server to select.
    Setting this will cause the module to select a server and short circuit.
    This is useful for when you want to use the module to ensure a server exists, but not manage it.
    Leave this blank to create a new server.
    If you provide this value, all other values will be ignored.
    No additional processing will occur than selecting the server.
  EOT
  default     = ""
}
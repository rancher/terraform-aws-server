
variable "owner" {
  type        = string
  description = <<-EOT
    The owner to tag resources with.
    If you are using the "id" field then this field is ignored.
  EOT
}

variable "name" {
  type        = string
  description = <<-EOT
    The name to give the server.
    If you are using the "id" field then this field is ignored.
  EOT
}

variable "user" {
  type        = string
  description = <<-EOT
    The user to install on the server, it will have sudo access.
    If you are using the "id" field then this field is ignored.
  EOT
}

variable "type" {
  type        = string
  description = <<-EOT
    The designation from types.tf of the EC2 instance type to use.
    If you are using the "id" field then this field is ignored.
  EOT
}

variable "image_id" {
  type        = string
  description = <<-EOT
    The id of the AMI to use.
    If you are using the "id" field then this field is ignored.
  EOT
}

variable "image_initial_user" {
  type        = string
  description = <<-EOT
    The initial or default user on the AMI.
    If you are using the "id" field then this field is ignored.
  EOT
}

variable "image_admin_group" {
  type        = string
  description = <<-EOT
    The group defined as an 'admin' on the AMI.
    If you are using the "id" field then this field is ignored.
  EOT
}
variable "image_workfolder" {
  type        = string
  description = <<-EOT
    The folder where scripts will be copied to and run from.
    If you are using the "id" field then this field is ignored.
    This defaults to "/home/<image_initial_user>", and is usually safe.
    If your home directory is mounted with noexec, you will need to change this.
  EOT
  default     = ""
}

variable "ssh_key" {
  type        = string
  description = <<-EOT
    The contents of the public key to add to the server for ssh access.
    If you are using the "id" field then this field is ignored.
  EOT
}
variable "ssh_key_name" {
  type        = string
  description = <<-EOT
    The name of the ssh key pair which already exists in AWS to apply to the server.
  EOT
  default     = ""
}
variable "security_group" {
  type        = string
  description = <<-EOT
    The name of the security group which already exists in AWS to apply to the server.
    WARNING: Security groups are region specific, so if you are using this module in multiple regions, you will need to create a security group in each region.
    It is helpful to use the same name for security groups across regions.
    If you would like help accomplishing this, see the terraform-aws-access module that we produce.
    If you are using the "id" field then this field is ignored.
  EOT
}

variable "subnet" {
  type        = string
  description = <<-EOT
    The name of the subnet which already exists in AWS to provision the server on.
    WARNING: Subnets are region specific, so if you are using this module in multiple regions, you will need to create a subnet in each region.
    It is helpful to use the same name for subnets across regions.
    If you would like help accomplishing this, see the terraform-aws-access module that we produce.
    If you are using the "id" field then this field is ignored.
  EOT
}

variable "id" {
  type        = string
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


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
  default     = "~"
}
variable "skip_key" {
  type        = bool
  description = <<-EOT
    Set this to true to skip the association of an ssh key to the server.
  EOT
  default     = false
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
  EOT
}
variable "security_group_association_force_create" {
  type        = bool
  description = <<-EOT
    Setting this to true will force the creation of an association object between the server and security group.
    Normally this association will only be created when a new server is created.
    This can be useful when isolating the lifecycle of the security group.
  EOT
  default     = false
}
variable "ip" {
  type        = string
  description = <<-EOT
    Ipv4 address to associate with the server, it must be within the usable addresses in the subnet given.
  EOT
  default     = ""
}
variable "ipv6" {
  type        = string
  description = <<-EOT
    Ipv6 address to associate with the server, it must be within the usable addresses in the subnet given.
  EOT
  default     = ""
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

variable "cloudinit_script" {
  type        = string
  description = <<-EOT
    A script for cloud-init to run.
  EOT
  default     = ""
}

variable "cloudinit_timeout" {
  type        = string
  description = <<-EOT
    The number of minutes to wait for cloud-init to finish.
    Defaults to '5' which checks the cloud-init status for 'done' every 10 seconds for 5 minutes / 300 seconds.
  EOT
  default     = "5"
}

variable "disable_scripts" {
  type        = bool
  description = <<-EOT
    Normally there are a number of scripts that we run on every server to set it up.
    This includes validating that cloud-init completed successfully, 
      removing the initial user, generating a user for the CI, etc.
    Enable this flag to disable all of those scripts, this is useful when ssh is disabled on the server.
  EOT
  default     = false
}
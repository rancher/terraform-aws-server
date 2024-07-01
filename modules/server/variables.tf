variable "use" {
  type        = string
  description = <<-EOT
    The strategy to use for selecting or creating a server.
    Options are "select" or "create".
  EOT
  default     = "create"
}
variable "id" {
  type        = string
  description = <<-EOT
    The id of a server to select.
    This should be blank when creating a new server.
    If you are using this field then the other fields are ignored.
    No additional resources are created when selecting a resource.
  EOT
  default     = ""
}
variable "name" {
  type        = string
  description = <<-EOT
    The name to give the new server.
  EOT
  default     = ""
}
variable "type" {
  type        = string
  description = <<-EOT
    The designation from types.tf of the EC2 instance type to create.
  EOT
}
variable "image" {
  type = object({
    id          = string
    user        = string
    admin_group = string
    workfolder  = string
  })
  description = <<-EOT
    The image object to use for creating the ec2 instance.
  EOT
  default = {
    id          = ""
    user        = ""
    admin_group = ""
    workfolder  = ""
  }
}
variable "subnet" {
  type        = string
  description = <<-EOT
    The name of the subnet which already exists in AWS to attach to the server.
    WARNING: Subnets are availability zone specific,
      so this is selecting an availability zone for the server.
  EOT
  default     = ""
}
variable "security_group" {
  type        = string
  description = <<-EOT
    The name of the security group which already exists in AWS to 
      attach to the server.
  EOT
  default     = ""
}
variable "ip" {
  type        = string
  description = <<-EOT
    Private IP address to associate with the server,
     it must be within the usable addresses in the subnet given.
  EOT
  default     = ""
}
variable "cloudinit" {
  type        = string
  description = <<-EOT
    The cloud-init config or user-data to send to the server.
    In some cases the OS may prevent cloud-init from writing to the filesystem,
      most commonly seen in STIG CIS hardened images.
  EOT
  default     = ""
}
variable "aws_keypair_use_strategy" {
  type        = string
  description = <<-EOT
    The strategy to use when adding a new ssh key to the server.
    Valid values are: create,select,skip
  EOT
  default     = "skip"
}
variable "ssh_key" {
  type        = string
  description = <<-EOT
    The content of an ssh key to place on the server.
    In most cases you should use the cloud init to do this,
    but there are a few instances where this is not possible (CIS STIG).
    This will only work if the aws_keypair_use_strategy isn't set to skip.
  EOT
  default     = ""
}
variable "ssh_key_name" {
  type        = string
  description = <<-EOT
    A name to give the ssh key that is created or 
    the name of an existing ssh key to select.
    This will only work if the aws_keypair_use_strategy isn't set to skip.
  EOT
  default     = ""
}

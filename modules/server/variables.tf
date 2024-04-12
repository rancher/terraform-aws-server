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
    id           = string
    initial_user = string
    admin_group  = string
    workfolder   = string
  })
  description = <<-EOT
    The image object to use for creating the ec2 instance.
  EOT
  default = {
    id           = ""
    initial_user = ""
    admin_group  = ""
    workfolder   = ""
  }
}
variable "subnet" {
  type        = string
  description = <<-EOT
    The name of the subnet which already exists in AWS to 
      attach to the server.
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

variable "eip" {
  type        = bool
  description = <<-EOT
    Set this to true to deploy a public elastic IP address with this server.
  EOT
  default     = false
}
variable "server_ports" {
  type        = list(number)
  description = <<-EOT
    List of ports to allow ingress to the server.
  EOT
  default     = []
}
variable "load_balancer_use" {
  type        = string
  description = <<-EOT
    The strategy to use for selecting or creating a load balancer.
    Options are "select" or "skip".
  EOT
  default     = "select"
}
variable "load_balanced_ports" {
  type        = list(number)
  description = <<-EOT
    List of ports to forward to the server from the load balancer.
  EOT
  default     = []
}
variable "load_balancer" {
  type        = string
  description = <<-EOT
    The name of the load balancer to attach the server to.
  EOT
  default     = ""
}
variable "access_ips" {
  type        = list(string)
  description = <<-EOT
    List of CIDR blocks to allow ingress access to the server.
  EOT
  default     = []
}
variable "domain_use" {
  type        = string
  description = <<-EOT
    The strategy to use for selecting, creating, or skipping a domain.
    Options are "select", "create", or "skip".
  EOT
  default     = "create"
}
variable "domain" {
  type        = string
  description = <<-EOT
    The domain name to associate with the server.
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
variable "cloudinit_timeout" {
  type        = number
  description = <<-EOT
    The number of minutes to wait for cloud-init to complete.
  EOT
  default     = 5
}
variable "setup" {
  type        = bool
  description = <<-EOT
    Sane default script to run on the server to set it up.
    This will generate a user with sodoers access and ssh key login.
    The goal is to provide a normal secure way to access the server for further setup.
    This is ignored when selecting a server, no action will be taken against the selected server.
  EOT
  default     = true
}
variable "user" {
  type        = string
  description = <<-EOT
    The username to create on the server.
  EOT
  default     = ""
}
variable "ssh_key" {
  type        = string
  description = <<-EOT
    The public ssh key to add to the user's authorized_keys file.
  EOT
  default     = ""
}

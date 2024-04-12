variable "use_strategy" {
  type        = string
  description = <<-EOT
    Strategy to use when setting up direct access.
    If set to `network`, we will generate security groups to 
      allow network access to the addresses specified.
    If set to `ssh`, we will generate security groups to allow network access,
     then we will add a user and ssh key to the instance.
  EOT
  validation {
    condition     = contains(["network", "ssh"], var.use_strategy)
    error_message = "The use_strategy value must be either `network` or `ssh`."
  }
}
variable "server" {
  type = object({
    id                   = string
    name                 = string
    network_interface_id = string
    public_ip            = string
    vpc_id               = string
  })
  description = <<-EOT
    The server to associate the EIP with.
    We will attach the EIP to the primary network interface,
      this will allow the server to be remade without detaching the EIP.
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
    Image object with info necessary to configure ssh access.
  EOT
}

variable "access_addresses" {
  type        = map(list(string))
  description = <<-EOT
    A map where the key is the port number and the value is a list of CIDRs to allow.
    An example would be {"22" = ["0.0.0.0/0"]} to allow ssh access from anywhere.
    Another example: {"22" = ["1.1.1.1/32"], "80" = ["100.0.1.1/8","1.1.1.1/32"]}
  EOT
}

variable "ssh" {
  type = object({
    user            = string
    user_workfolder = string
    public_ssh_key  = string
    timeout         = number
  })
  description = <<-EOT
    This is required if use_strategy is "ssh".
    The user specified will be added to the server with passwordless sudo access.
    The user_workfolder is the path where scripts can be run for this user, usually '/home/<user>'.
    The public_ssh_key will be added to the /home/<user>/.ssh/authorized_keys file.
    The timeout value is the number of minutes to wait for setup to complete, defaults to 5.
  EOT
}

variable "add_domain" {
  type        = bool
  description = <<-EOT
    If true we will create a domain based on the info in the domain variable.
  EOT
}

variable "domain" {
  type = object({
    name = string
    zone = string
    type = string
    ips  = list(string)
  })
  description = <<-EOT
    This is required if add_domain is true.
    The name is the name of the domain to add.
    The zone_id is the zone id of the domain to add.
    The type is the type of domain to add, one of 'A' or 'AAAA'.
    ips is the the ip addresses to add to the domain.
  EOT
}

variable "add_eip" {
  type        = bool
  description = <<-EOT
    If set to true, we will add an elastic ip to the instance.
  EOT
}

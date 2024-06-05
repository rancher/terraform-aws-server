# this server module must be aware of the system requirements of the application that will run on it
# this is fundamental to generating servers, you need to know the size and how many servers you need
# with that in mind we also need to know what ports to expose and how to route traffic
# this module is generalized so that it can be used for any application

#####
# Feature: image
#####
variable "image_use_strategy" {
  type        = string
  description = <<-EOT
    The strategy to use for selecting an image.
    This can be "find" to use our selection of types, "select" to select an image by id, or "skip" to do nothing.
    If you choose "find" you must set the image_type variable.
    If you choose "select" you must set the image variable.
    If you select "skip" no image will be created or selected and data will be empty.
    If you select "skip" dependent resources will be skipped implicitly (including the server mod).
  EOT
  default     = "find"
  validation {
    condition = (
      contains(["find", "select", "skip"], var.image_use_strategy)
    )
    error_message = "This must be one of 'find','select', or 'skip'."
  }
}

# image select
variable "image" {
  type = object({
    id          = string
    user        = string
    admin_group = string
    workfolder  = string
  })
  description = <<-EOT
    Custom image object used when selecting an image by id.
    This variable is required when the image_use_strategy is "select".
    This variable is ignored when the image_use_strategy isn't "select".
    Id attribute is required, the others can be "" unless the 
    direct_access_use_strategy is "ssh".
    The id attribute is the AMS image id.
    The user attribute is the sudo user which already exists on the image.
    The admin_group is the group name for sudo users, eg. "wheel".
    The workfolder is a folder that the user has access to that can execute scripts.
    On most images this can set to "~" to use the user's home directory,
    but on some images (eg. CIS STIG AMIs) a different directory is necessary.
  EOT
  default     = null
}

# image find
variable "image_type" {
  type        = string
  description = <<-EOT
    The designation of server "image" from the ./image/types.tf file, this relates the AWS AMI information.
    Please be aware that some images require a subscription and will have additional cost over usage of the server.
    Current images are:
        "sles-15",
        "sle-micro-55",
        "rhel-8-cis",
        "ubuntu-20",
        "ubuntu-22",
        "rocky-8",
        "liberty-7",
        "rhel-8",
        "rhel-9"
  EOT
  default     = ""
  validation {
    condition = (
      var.image_type == "" ? true : contains([
        "sles-15",
        "sle-micro-55",
        "rhel-8-cis",
        "ubuntu-20",
        "ubuntu-22",
        "rocky-8",
        "liberty-7",
        "rhel-8",
        "rhel-9",
      ], var.image_type)
    )
    error_message = <<-EOT
      If specified, this must be one of 
        "sles-15",
        "sle-micro-55",
        "rhel-8-cis",
        "ubuntu-20",
        "ubuntu-22",
        "rocky-8",
        "liberty-7",
        "rhel-8",
        "rhel-9"
    EOT
  }
}



#####
# Feature: server
#####

variable "server_use_strategy" {
  type        = string
  description = <<-EOT
    The strategy to use for selecting a server.
    This can be "create" to create a new server, "select" to select an existing server, or "skip" to do nothing.
    If you choose "select" you must provide the id of the server to select.
    WARNING! No action will be taken and no resources generated by this module when selecting a server,
     all variables except the server_id will be ignored.
    If you select "skip" no server will be created or selected and data will be empty.
    If you select "skip" dependent resources will be skipped implicitly.
  EOT
  default     = "create"
}
variable "server_id" {
  type        = string
  description = <<-EOT
    The id of the AWS Ec2 instance that you want to select.
    This should only be used when you want to select an existing server, and not create a new one.
    This can be helpful if you want to ensure a server exists and get data about it, without managing it.
    This variable is ignored if server_use_strategy isn't "select".
  EOT
  default     = ""
}
variable "server_name" {
  type        = string
  description = <<-EOT
    The name to give the server, this will form the local hostname and appear in the AWS ec2 console.
    The name will be used as the value for the "Name" tag on the server.
    This value is ignored when selecting a server.
  EOT
  default     = ""
}
variable "server_type" {
  type        = string
  description = <<-EOT
    The designation of server "type" from the ./server/types.tf file
    This will set the cpu, ram, and storage resources available to the server.
    Larger types will have higher costs, none of the types listed are in the free tier.
    Current types are "small", "medium", "large", "xl", "xxl"
    Leave this blank when selecting a server.
  EOT
  default     = ""
  validation {
    condition = (
      var.server_type == "" ? true : contains(["small", "medium", "large", "xl", "xxl"], var.server_type)
    )
    error_message = "If specified, this must be one of 'small', 'medium', 'large', 'xl', or 'xxl'."
  }
}
variable "cloudinit_use_strategy" {
  type        = string
  description = <<-EOT
    The strategy to use for cloudinit, must be one of "skip", "default", or "specify".
    This can be "skip" to skip sending cloudinit, "create" to generate a cloudinit script with defaults, 
    or "specify" to specify your own cloudinit content.
    This is ignored when skipping or selecting a server or when direct_access_use_strategy isn't "ssh".
  EOT  
  validation {
    condition = (
      var.cloudinit_use_strategy == "" ? true : contains(["skip", "default", "specify"], var.cloudinit_use_strategy)
    )
    error_message = "If specified, this must be one of 'skip', 'default', or 'specify'."
  }
  default = "skip"
}
variable "cloudinit_content" {
  type        = string
  description = <<-EOT
    Override the default cloud-init config.
    This is a yaml formatted string that will be sent as base64 encoded "user-data" to the EC2 api when creating the server.
    This should be raw text, the module will handle the base64 encoding.
    WARNING!! Some OS configurations prevent cloud-init from writing files, such as STIG CIS AMIs.
  EOT
  default     = ""
  sensitive   = true
}


#####
# Feature: internal access
#####
# these variables are used to configure how servers connect within the scope of the VPC

variable "subnet_name" {
  type        = string
  description = <<-EOT
    The name of the AWS subnet that you want to apply to the server.
    This must already exist in AWS, it will not be created by this module.
    If you would like help creating a subnet, please see the 'terraform-aws-access' module that we produce.
    This uses the "Name" tag on the subnet to select it, this is preferrable to make multi-region deployments easier.
    Subnets are tied to a specific availability zone, so when you select a subnet you are also selecting an availability zone.
  EOT
  default     = ""
}
variable "security_group_name" {
  type        = string
  description = <<-EOT
    The name of the AWS security group that you want to apply to the server.
    This must already exist in AWS, it will not be created by this module.
    If you would like help creating a security group, please see the 'terraform-aws-access' module that we produce.
    This uses the "Name" tag on the security group to select it, this generalizes the approach for finding objects in AWS.
    The name must be unique to all of your objects, you can't have a security group and a load balancer with the same name.
    This name can't start with 'sg-', as AWS reserves this prefix for its use.
  EOT
  default     = ""
}
variable "private_ip" {
  type        = string
  description = <<-EOT
    An available private ip to assign to the server.
    This must be within the subnet assigned to the server.
    If one is not set we will use the next to last ip in the subnet.
  EOT
  default     = ""
}



#####
# Feature: indirect access
#####

variable "indirect_access_use_strategy" {
  type        = string
  description = <<-EOT
    The strategy to use for a load balancer.
    This can be "enable" to select an existing load balancer, or "skip" to do nothing.
    If you choose "enable" you must provide the name of the load balancer to select in the load_balancer_name variable.
    If you choose "skip" no load balancer will be created or selected and data will be empty.
  EOT
  default     = "skip"
  validation {
    condition = (
      contains(["enable", "skip"], var.indirect_access_use_strategy)
    )
    error_message = "This must be one of 'enable' or 'skip'."
  }
}
variable "load_balancer_target_groups" {
  type        = list(string)
  description = <<-EOT
    The names of the target groups to attach the server to.
    This must be a list of strings, each string is the name of a target group.
    This is only used if indirect_access_use_strategy is set to "enable".
    The target_group must have a tag "Name" with this exact value.
  EOT
  default     = []
}


#####
# Feature: direct access
#####
# options here are for direct access to the server from outside the VPC, this is not recommended for production
variable "direct_access_use_strategy" {
  type        = string
  description = <<-EOT
    The strategy to use for direct access to the server.
    This can be "network", "ssh", or "skip".
    If you choose 'skip' nothing will be done and server_access_addresses, server_user, ssh_key_content, domain, and eip variables will be ignored.
    If you choose "network" only network level access will be created, and server_access_addresses is required.
    If you choose "ssh", then network level access will be created as well as ssh access.
    To enable ssh access we connect to the server over ssh and run scripts which remove the default user, add a new user, 
    and add the specified public ssh key to the new user. The server_user variable is required.
    Optionally, you may add a domain name or an elastic ip to your server with the add_eip and add_domain variables.
  EOT
  default     = "skip"
  validation {
    condition = (
      contains(["network", "ssh", "skip"], var.direct_access_use_strategy)
    )
    error_message = "This must be one of 'network', 'ssh', or 'skip'."
  }
}
variable "server_access_addresses" {
  type = map(object({
    port     = number
    cidrs    = list(string)
    protocol = string
  }))
  default     = null
  description = <<-EOT
    A map of objects with a single port, the cidrs to allow access to that port,
    and the protocol to allow for access.
    The port is the tcp port number to expose. eg. 80
    The cidrs is a list of cidrs to allow to that port. eg ["1.1.1.1/32","2.2.2.2/24"]
    The protocol is the tranfer protocol to allow, usually "tcp" or "udp".
    Example: 
      {
        workstation = {
          port = 443,
          cidrs = ["100.1.1.1/32"],
          protocol = "tcp"
        }
        ci = {
          port = 443
          cidrs = ["50.1.1.1/32"],
          protocol = "tcp"
        }
      }
  EOT
}
variable "server_user" {
  type = object({
    user                     = string
    aws_keypair_use_strategy = string
    ssh_key_name             = string
    public_ssh_key           = string
    user_workfolder          = string
    timeout                  = number
  })
  description = <<-EOT
    This is required if direct_access_use_strategy is "ssh".
    The user specified will be added to the server with passwordless sudo access.
    The public_ssh_key will be added to the /home/<user>/.ssh/authorized_keys file.
    The timeout value is the number of minutes to wait for setup to complete, defaults to 5.
    Some images must have an ssh key passed to the cloud provider when generating the server (CIS STIG),
    to enable this set the aws_keypair_use_strategy to either "select" or "create".
    Select will select the ssh key with the name attribute equal to the "ssh_key_name" specified.
    Create will create a new ssh key with the given name and public ssh key. (ssh keypair objects can't have tags).
  EOT
  default     = null
  validation {
    condition     = (var.server_user == null ? true : (length(var.server_user["user"]) <= 32 ? true : false))
    error_message = "If specified, user must be 32 characters or less."
  }
  validation {
    condition     = (var.server_user == null ? true : (var.server_user["user"] == lower(var.server_user["user"]) ? true : false))
    error_message = "If specified, user must be all lower case."
  }
}
variable "add_domain" {
  type        = bool
  description = <<-EOT
    When this is true domain_name and domain_zone is required.
    This will add a record with the server's public IP address to route53.
    You must already have a zone setup and configured properly for this to work.
  EOT
  default     = false
}
variable "domain_name" {
  type        = string
  description = <<-EOT
    The domain name to use for the server.
    The zone for this domain must already exist in route53.
    The domain_zone variable is required when this is set.
  EOT
  default     = ""
}
variable "domain_zone" {
  type        = string
  description = <<-EOT
    The zone for the domain name.
    The domain_name variable is required when this is set.
  EOT
  default     = ""
}
variable "add_eip" {
  type        = bool
  description = <<-EOT
    Set this to true to add an elastic IP to the server.
    WARNING! By default, all AWS accounts have a quota of five (5) Elastic IP addresses per Region.
    You can change this in your account quota settings.
    Some programs (such as kubernetes) require the IP on the primary interface to remain stable,
      this can be achieved by specifying the private_ip variable rather than using an elastic IP.
  EOT
  default     = false
}

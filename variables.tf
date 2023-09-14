variable "name" {
  type        = string
  description = <<-EOT
    The name to give the server, this will form the local hostname and appear in the AWS ec2 console.
    The name should be unique within your region.
    The name will be used as the value for the "Name" tag on the server.
    The name should give some indication of the purpose of the server.
    This value is ignored when overriding with the id.
    If both the name and id are empty, no server will be created or selected and data will be empty.
  EOT
  default     = ""
}

variable "owner" {
  type        = string
  description = <<-EOT
    The value of the "Owner" tag which will be added to resources, usually this is your email address.
    Adding your email address as a tag on resources allows your teammates to contact you about the resource.
    This can help prevent accidental deletion of resources or unexpected charges.
    This value is ignored when overriding with the id.
  EOT
  default     = ""
}

variable "type" {
  type        = string
  description = <<-EOT
    The designation of server "type" from the ./server/types.tf file
    This will set the cpu, ram, and storage resources available to the server.
    Larger types will have higher costs, none of the types listed are in the free tier.
    Current types are "small", "medium", "large", "xl", "xxl"
    This value is ignored when overriding with the id.
  EOT
  default     = ""
}

variable "image" {
  type        = string
  description = <<-EOT
    The designation of server "image" from the ./image/types.tf file, this relates the AWS AMI information.
    Please be aware that some images require a subscription and will have additional cost over usage of the server.
    Current images are "sles-15", "ubuntu-22", "ubuntu-20", "rhel-8", "rocky-8", "sles-15-cis".
    This value is ignored when overriding with the image_id.
    Please specify either image_id or image_type.
  EOT
  default     = ""
}

variable "image_initial_user" {
  type        = string
  description = <<-EOT
    The initial or default user on the AMI, this will be used to configure initial connection.
    Use this only when overriding with the image_id (we already know initial users for preselected types).
  EOT
  default     = ""
}

variable "image_admin_group" {
  type        = string
  description = <<-EOT
    The group defined as an 'admin' or 'sudoer' on the AMI, must allow sudo access.
    Use this only when overriding with the image_id (we already know the admin group for preselected types).
  EOT
  default     = ""
}

variable "image_id" {
  type        = string
  description = <<-EOT
    The id of the AMI to use. This is the AWS AMI id, not the id from the ./image/types.tf file.
    Use this only when you need to use an AMI that is not listed in the ./image/types.tf file.
    If you use this, the image_type variable will be ignored.
    Please specify either image_id or image_type.
    If you use this, the image_initial_user and image_admin_group variables are required.
  EOT
  default     = ""
}

variable "user" {
  type        = string
  description = <<-EOT
    The username to add to the server for configuring the OS and provisioning software.
    The user will get sudo access without a password, password authentication over remote connections is diabled.
    The only way to access the server is by ssh-key using the user specified here.
    This value is ignored when overriding with id.
    If specified, this must be 32 characters or less.
  EOT
  default     = ""
  validation {
    condition = (
      var.user == "" ? true : (length(var.user) <= 32 ? true : false)
    )
    error_message = "If specified, this must be 32 characters or less."
  }
}

variable "ssh_key" {
  type        = string
  description = <<-EOT
    The contents of the public key to use for ssh access.
    This will be placed in the /home/.ssh/authorized_keys for the user provided.
    This value is ignored when overriding with the id.
  EOT
  default     = ""
}

variable "security_group_name" {
  type        = string
  description = <<-EOT
    The name of the AWS security group that you want to apply to the server.
    This must already exist in AWS, it will not be created by this module.
    If you would like help creating a security group, please see the 'terraform-aws-access' module that we produce.
    This uses the "Name" tag on the security group to select it, this is preferrable to make multi-region deployments easier.
  EOT
  default     = ""
}

variable "subnet_name" {
  type        = string
  description = <<-EOT
    The name of the AWS subnet that you want to apply to the server.
    This must already exist in AWS, it will not be created by this module.
    If you would like help creating a subnet, please see the 'terraform-aws-access' module that we produce.
    This uses the "Name" tag on the subnet to select it, this is preferrable to make multi-region deployments easier.
  EOT
  default     = ""
}

variable "id" {
  type        = string
  description = <<-EOT
    The id of the AWS Ec2 instance that you want to select.
    This must already exist in AWS, it will not be created by this module.
    This should only be used when you want to select an existing server, and not create a new one.
    This can be helpful if you want to ensure a server exists and get data about it, without managing it.
    If you would like to create a server, leave this empty.
    If both the name and id are empty, no server will be created or selected and data will be empty.
  EOT
  default     = ""
}

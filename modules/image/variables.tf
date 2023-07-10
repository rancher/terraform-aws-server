variable "id" {
  description = <<-EOT
    An AMI to select.
    Don't use this is if you want to search for an AMI.
    WARNING! AMI's are region specific.
  EOT
  default     = ""
}
variable "type" {
  description = <<-EOT
    A type from the types.tf file.
    Types represent a standard set of opinionated options that we select for you.
    Don't use this if you want to supply your own AMI id.
  EOT
  default     = ""
}
variable "initial_user" {
  description = <<-EOT
    This isn't used if a type is selected.
    The initial user on the AMI, this is used for the initial connection.
    The initial connection is used to set up secure access for the user.
    This is required if you are supplying your own AMI id.
  EOT
  default     = ""
}
variable "admin_group" {
  description = <<-EOT
    The linux group considered 'admin' on the AMI.
    The initial user will be added to this group, it must have sudo access.
    This is required if you are supplying your own AMI id.
  EOT
  default     = ""
}

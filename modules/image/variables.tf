variable "use_strategy" {
  type        = string
  description = <<-EOT
    Whether to find or select an image.
    If set to `find`, type is required and must be in the list of types.
    If set to `select`, type is ignored and image is required.
  EOT
  validation {
    condition     = contains(["find", "select"], var.use_strategy)
    error_message = "The use_strategy value must be either `find` or `select`."
  }
}
variable "type" {
  type        = string
  description = <<-EOT
    A type from the types.tf file.
    Types represent a standard set of opinionated options that we select for you.
    Don't use this if you want to supply your own AMI id.
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
    An image type to inject and use.
    This is required when the use_strategy is "select".
  EOT
  default     = null
}

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
  default     = ""
}
variable "image" {
  type = object({
    id          = string
    user        = string
    admin_group = string
    workfolder  = string
  })
  description = <<-EOT
    An image type to use.
    This is required when the use_strategy is "select".
    Notice the id field, this is the AMI to select.
  EOT
  default = {
    id          = ""
    user        = ""
    admin_group = ""
    workfolder  = ""
  }
}

variable "custom_types" {
  type = map(object({
    user         = string
    group        = string
    name         = string
    name_regex   = string
    owners       = list(string)
    architecture = string
    workfolder   = string
  }))
  description = <<-EOT
    A custom type to inject into the types.tf file.
    This is helpful when you want to search for an AMI that is not in our selections.
    This simply adds the new type to the types, you must use the "find" use strategy and the new type's key as the type.
  EOT
  default = {
    dummy = {
      user         = ""
      group        = ""
      name         = ""
      name_regex   = ""
      owners       = []
      architecture = ""
      workfolder   = ""
    }
  }
}

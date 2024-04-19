variable "server_id" {
  type        = string
  description = <<-EOT
    The id of the server to add to the load balancer.
   EOT
}
variable "target_group_names" {
  type = list(string)
  description = <<-EOT
    List of target group names to add the server to.
    The name must be a tag on the target group with the key "Name".
  EOT
}

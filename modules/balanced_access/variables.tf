variable "name" {
  type        = string
  description = <<-EOT
    The name of the load balancer to add to.
    A load balancer with the tag "Name" equal to this value must already exist.
  EOT
}
variable "ports" {
  type        = list(number)
  description = <<-EOT
    List of ports to forward to the server.
    Example: [80, 443] would forward ports 80 and 443 to the server.
  EOT
}
variable "server" {
  type        = map(string)
  description = <<-EOT
    The server to add to the load balancer.
   EOT
}

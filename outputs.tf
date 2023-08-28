output "private_ip" {
  value       = (local.skip_server ? "" : module.server[0].private_ip)
  description = <<-EOT
    The IP of the server from inside the VPC.
  EOT
}
output "public_ip" {
  value       = (local.skip_server ? "" : module.server[0].public_ip)
  description = <<-EOT
    The IP of the server from outside the VPC.
  EOT
}
output "id" {
  value       = (local.skip_server ? "" : module.server[0].id)
  description = <<-EOT
    The unique ID of the server.
  EOT
}
output "ami" {
  value       = (local.skip_server ? module.image.ami : module.server[0].ami)
  description = <<-EOT
    The AMI used to create the server.
  EOT
}
output "ram" {
  value       = (local.skip_server ? "" : module.server[0].ram)
  description = <<-EOT
    The amount of RAM on the server.
  EOT
}
output "cpu" {
  value       = (local.skip_server ? "" : module.server[0].cpu)
  description = <<-EOT
    The number of CPUs on the server.
  EOT
}
output "storage" {
  value       = (local.skip_server ? "" : module.server[0].storage)
  description = <<-EOT
    The amount of storage in GB on the server.
  EOT
}
output "server" {
  value       = (local.skip_server ? null : module.server[0].server)
  description = <<-EOT
    The server object.
  EOT
}
output "user_data" {
  value       = (local.skip_server ? null : module.server[0].user_data)
  sensitive   = true
  description = <<-EOT
    The cloud-init user data sent when generating the server.
  EOT
}

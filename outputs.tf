output "private_ip" {
  value = (local.skip_server ? "" : module.server[0].private_ip)
}
output "public_ip" {
  value = (local.skip_server ? "" : module.server[0].public_ip)
}
output "id" {
  value = (local.skip_server ? "" : module.server[0].id)
}
output "ami" {
  value = (local.skip_server ? module.image.ami : module.server[0].ami)
}
output "ram" {
  value = (local.skip_server ? "" : module.server[0].ram)
}
output "cpu" {
  value = (local.skip_server ? "" : module.server[0].cpu)
}
output "storage" {
  value = (local.skip_server ? "" : module.server[0].storage)
}

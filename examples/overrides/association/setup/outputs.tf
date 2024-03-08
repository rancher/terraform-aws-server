output "private_ip" {
  value = module.this.private_ip
}
output "public_ip" {
  value = module.this.public_ip
}
output "id" {
  value = module.this.id
}
output "ami" {
  value = module.this.ami
}
output "ram" {
  value = module.this.ram
}
output "cpu" {
  value = module.this.cpu
}
output "storage" {
  value = module.this.storage
}
output "identifier" {
  value = local.identifier
}
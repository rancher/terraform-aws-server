output "private_ip" {
  value = (local.create ? aws_instance.created[0].private_ip : data.aws_instance.selected[0].private_ip)
}
output "public_ip" {
  value = (local.create ? aws_instance.created[0].public_ip : data.aws_instance.selected[0].public_ip)
}
output "id" {
  value = (local.create ? aws_instance.created[0].id : data.aws_instance.selected[0].id)
}
output "ami" {
  value = (local.create ? aws_instance.created[0].ami : data.aws_instance.selected[0].ami)
}
output "ram" {
  value = data.aws_ec2_instance_type.general_info.memory_size
}
output "cpu" {
  value = data.aws_ec2_instance_type.general_info.default_vcpus
}
output "storage" {
  value = (local.create ? (aws_instance.created[0].root_block_device[*].volume_size)[0] : (data.aws_instance.selected[0].root_block_device[*].volume_size)[0])
}

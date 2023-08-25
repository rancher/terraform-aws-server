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
output "server" {
  value = (local.create ? aws_instance.created[0] : data.aws_instance.selected[0])
}
# The AWS provider in Terraform uses the SHA-1 checksum to check if the user data has changed.
# The user_data attribute is actually the SHA-1 checksum of the user data.
# To get the Base64 encoded user data, you can use the user_data_base64 attribute instead of the user_data attribute.
# When creating an instance you need to use the user_data_base64 attribute to return the user_data_base64 value.
output "user_data" {
  value = (
    local.create ?
    (can(base64decode(aws_instance.created[0].user_data_base64)) ? base64decode(aws_instance.created[0].user_data_base64) : aws_instance.created[0].user_data) :
    (can(base64decode(data.aws_instance.selected[0].user_data_base64)) ? base64decode(data.aws_instance.selected[0].user_data_base64) : data.aws_instance.selected[0].user_data)
  )
}

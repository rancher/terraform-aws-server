output "server" {
  value = (local.create == 1 ? aws_instance.created[0] : data.aws_instance.selected[0])
}
output "server_type" {
  value = (local.create == 1 ? data.aws_ec2_instance_type.general_info_create[0] : data.aws_ec2_instance_type.general_info_select[0])
}
output "vpc" {
  value = (local.create == 1 ? data.aws_vpc.general_info_create[0] : data.aws_vpc.general_info_select[0])
}
output "subnet" {
  value = (local.create == 1 ? data.aws_subnet.general_info_create[0] : data.aws_subnet.general_info_select[0])
}
output "security_group" {
  value = (local.create == 1 ? data.aws_security_group.general_info_create[0] : data.aws_security_group.general_info_select[0])
}

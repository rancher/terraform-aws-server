output "id" {
  value       = try(data.aws_instance.selected[0].id, aws_instance.created[0].id, "")
  description = "The ID of the instance"
}
output "arn" {
  value       = try(data.aws_instance.selected[0].arn, aws_instance.created[0].arn, "")
  description = "The Amazon Resource Name (ARN) of the instance"
}
output "ami" {
  value       = try(data.aws_instance.selected[0].ami, aws_instance.created[0].ami, "")
  description = "The AMI ID of the instance"
}
output "type_id" {
  value = (local.create == 1 ? data.aws_ec2_instance_type.general_info_create[0].id : data.aws_ec2_instance_type.general_info_select[0].id)
}
output "vpc_id" {
  value = try(data.aws_vpc.general_info_create[0].id, data.aws_vpc.general_info_select[0].id, "")
}
output "subnet_id" {
  value       = try(data.aws_instance.selected[0].subnet_id, aws_instance.created[0].subnet_id, "")
  description = "The ID of the subnet"
}
output "availability_zone" {
  value       = try(data.aws_instance.selected[0].availability_zone, aws_instance.created[0].availability_zone, "")
  description = "The availability zone of the instance"
}
output "vpc_security_group_ids" {
  value = try(data.aws_instance.selected[0].vpc_security_group_ids, aws_instance.created[0].vpc_security_group_ids, tolist([]))
}
output "key_name" {
  value       = try(data.aws_instance.selected[0].key_name, aws_instance.created[0].key_name, "")
  description = "The key pair name for the instance"
}
output "private_ip" {
  value = (
    local.create == 1 ? (
      local.ip_family == "ipv4" ? aws_instance.created[0].private_ip :
      local.ip_family == "ipv6" ? tolist(aws_instance.created[0].ipv6_addresses)[0] : # no private ips for ipv6
      null
    ) :
    local.select == 1 ? (
      local.ip_family == "ipv4" ? data.aws_instance.selected[0].private_ip :
      local.ip_family == "ipv6" ? tolist(data.aws_instance.selected[0].ipv6_addresses)[0] : # no private ips for ipv6
      null
    ) :
    null
  )
  description = "The private IP address assigned to the instance"
}
output "public_ip" {
  value = (
    local.create == 1 ? (
      local.ip_family == "ipv4" ? aws_instance.created[0].public_ip :
      local.ip_family == "ipv6" ? tolist(aws_instance.created[0].ipv6_addresses)[0] :
      null
    ) :
    local.select == 1 ? (
      local.ip_family == "ipv4" ? data.aws_instance.selected[0].public_ip :
      local.ip_family == "ipv6" ? tolist(data.aws_instance.selected[0].ipv6_addresses)[0] :
      null
    ) :
    null
  )
  description = "The primary public IP address assigned to the instance"
}
output "public_dns" {
  value       = try(data.aws_instance.selected[0].public_dns, aws_instance.created[0].public_dns, "")
  description = "The public DNS name assigned to the instance"
}
output "ipv6_addresses" {
  value       = try(tolist(data.aws_instance.selected[0].ipv6_addresses), tolist(aws_instance.created[0].ipv6_addresses), tolist([]))
  description = "The IPv6 addresses for the instance"
}
output "network_interface_id" {
  value       = try(data.aws_instance.selected[0].network_interface_id, aws_instance.created[0].primary_network_interface_id, "")
  description = "The ID of the primary network interface"
}
output "root_block_device" {
  value       = try(data.aws_instance.selected[0].root_block_device, aws_instance.created[0].root_block_device[0])
  description = "The root block device attached to the instance"
}
output "user_data_base64" {
  value       = try(data.aws_instance.selected[0].user_data_base64, aws_instance.created[0].user_data_base64, "")
  description = "The user data for the instance in base64 format"
}
output "user_data_replace_on_change" {
  value       = try(aws_instance.created[0].user_data_replace_on_change, "unknown")
  description = "Whether to replace the user data on change"
}
output "instance_state" {
  value       = try(data.aws_instance.selected[0].instance_state, aws_instance.created[0].instance_state, "")
  description = "The state of the instance"
}
output "instance_initiated_shutdown_behavior" {
  value       = try(aws_instance.created[0].instance_initiated_shutdown_behavior, "unknown")
  description = "The shutdown behavior of the instance"
}
output "volume_tags" {
  value       = try(aws_instance.created[0].volume_tags, tomap({ "" = "" }))
  description = "The tags assigned to the volumes"
}
output "tags_all" {
  value       = try(data.aws_instance.selected[0].tags, aws_instance.created[0].tags_all)
  description = "All the tags assigned to the instance"
}

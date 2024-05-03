output "type" {
  value = (local.create == 1 ? data.aws_ec2_instance_type.general_info_create[0] : data.aws_ec2_instance_type.general_info_select[0])
}
output "vpc" {
  value = (local.create == 1 ? data.aws_vpc.general_info_create[0] : data.aws_vpc.general_info_select[0])
}
output "subnet" {
  value = (local.create == 1 ? data.aws_subnet.general_info_create[0] : data.aws_subnet.general_info_select[0])
}
output "security_group" {
  value = (local.create == 1 ? data.aws_security_group.general_info_create[0] : try(tolist(data.aws_instance.selected[0].security_groups)[0],null))
}

output "id" {
 value = try(data.aws_instance.selected[0].id, resource.aws_instance.created[0].id)
 description = "The ID of the instance"
}

output "ami" {
 value = try(data.aws_instance.selected[0].ami, resource.aws_instance.created[0].ami)
 description = "The AMI ID of the instance"
}

output "arn" {
 value = try(data.aws_instance.selected[0].arn, resource.aws_instance.created[0].arn)
 description = "The Amazon Resource Name (ARN) of the instance"
}

output "associate_public_ip_address" {
 value = try(data.aws_instance.selected[0].associate_public_ip_address, resource.aws_instance.created[0].associate_public_ip_address)
 description = "Whether the instance is associated with a public IP address"
}

output "availability_zone" {
 value = try(data.aws_instance.selected[0].availability_zone, resource.aws_instance.created[0].availability_zone)
 description = "The availability zone of the instance"
}

output "ebs_block_device" {
 value = try(data.aws_instance.selected[0].ebs_block_device, resource.aws_instance.created[0].ebs_block_device)
 description = "The EBS block device attached to the instance"
}

output "ebs_optimized" {
 value = try(data.aws_instance.selected[0].ebs_optimized, resource.aws_instance.created[0].ebs_optimized)
 description = "Whether the instance is EBS-optimized"
}

output "host_id" {
 value = try(data.aws_instance.selected[0].host_id, resource.aws_instance.created[0].host_id)
 description = "The ID of the host"
}

output "instance_state" {
 value = try(data.aws_instance.selected[0].instance_state, resource.aws_instance.created[0].instance_state)
 description = "The state of the instance"
}

output "instance_initiated_shutdown_behavior" {
 value = try(resource.aws_instance.created[0].instance_initiated_shutdown_behavior, "unknown")
 description = "The shutdown behavior of the instance"
}

output "ipv6_addresses" {
 value = try(data.aws_instance.selected[0].ipv6_addresses, resource.aws_instance.created[0].ipv6_addresses)
 description = "The IPv6 addresses for the instance"
}

output "key_name" {
 value = try(data.aws_instance.selected[0].key_name, resource.aws_instance.created[0].key_name)
 description = "The key pair name for the instance"
}

output "network_interface" {
 value = try(aws_network_interface.created[0], "unknown")
 description = "The network interface attached to the instance"
}

output "primary_network_interface_id" {
 value = try(resource.aws_instance.created[0].primary_network_interface_id, "unknown")
 description = "The ID of the primary network interface"
}

output "private_ip" {
 value = try(data.aws_instance.selected[0].private_ip, resource.aws_instance.created[0].private_ip)
 description = "The private IP address assigned to the instance"
}

output "public_dns" {
 value = try(data.aws_instance.selected[0].public_dns, resource.aws_instance.created[0].public_dns)
 description = "The public DNS name assigned to the instance"
}

output "public_ip" {
 value = try(data.aws_instance.selected[0].public_ip, resource.aws_instance.created[0].public_ip)
 description = "The public IP address assigned to the instance"
}

output "root_block_device" {
 value = try(data.aws_instance.selected[0].root_block_device, resource.aws_instance.created[0].root_block_device)
 description = "The root block device attached to the instance"
}

output "security_groups" {
 value = try(data.aws_instance.selected[0].security_groups, resource.aws_instance.created[0].security_groups)
 description = "The security groups associated with the instance"
}

output "subnet_id" {
 value = try(data.aws_instance.selected[0].subnet_id, resource.aws_instance.created[0].subnet_id)
 description = "The ID of the subnet"
}

output "tags" {
 value = try(data.aws_instance.selected[0].tags, resource.aws_instance.created[0].tags)
 description = "The tags assigned to the instance"
}

output "tags_all" {
 value = try(data.aws_instance.selected[0].tags, resource.aws_instance.created[0].tags_all)
 description = "All the tags assigned to the instance"
}

output "user_data_base64" {
 value = try(data.aws_instance.selected[0].user_data_base64, resource.aws_instance.created[0].user_data_base64)
 description = "The user data for the instance in base64 format"
}

output "user_data_replace_on_change" {
 value = try(resource.aws_instance.created[0].user_data_replace_on_change, "unknown")
 description = "Whether to replace the user data on change"
}

output "volume_tags" {
 value = try(resource.aws_instance.created[0].volume_tags, tomap({"" = ""}))
 description = "The tags assigned to the volumes"
}

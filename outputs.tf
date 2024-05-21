output "server" {
  value = {
    id                                = try(module.server[0].id, "")
    type_id                           = try(module.server[0].type_id, "")
    vpc_id                            = try(module.server[0].vpc_id, "")
    subnet_id                         = try(module.server[0].subnet_id, "")
    availability_zone                 = try(module.server[0].availability_zone, "")
    security_group_ids                = try(module.server[0].vpc_security_group_ids, tolist([]))
    key_name                          = try(module.server[0].key_name, "")
    private_ip                        = try(module.server[0].private_ip, "")
    public_ip                         = try(coalesce(module.server[0].public_ip, module.direct_access[0].eip.public_ip), "")
    public_dns                        = try(module.server[0].public_dns, "")
    ipv6_addresses                    = try(module.server[0].ipv6_addresses, tolist([]))
    primary_network_interface_id      = try(module.server[0].primary_network_interface_id, "")
    root_volume_id                    = try(module.server[0].root_block_device.volume_id, "")
    root_volume_size                  = try(module.server[0].root_block_device.volume_size, "")
    root_volume_tags                  = try(module.server[0].root_block_device.tags_all, tomap({ "" = "" }))
    root_volume_encrypted             = try(module.server[0].root_block_device.encrypted, false)
    root_volume_delete_on_termination = try(module.server[0].root_block_device.delete_on_termination, false)
    user_data_base64                  = try(module.server[0].user_data_base64, "")
    user_data_replace_on_change       = try(module.server[0].user_data_replace_on_change, false)
    instance_state                    = try(module.server[0].instance_state, "")
    shutdown_behavior                 = try(module.server[0].instance_initiated_shutdown_behavior, "")
    volume_tags                       = try(module.server[0].volume_tags, tomap({ "" = "" }))
    tags_all                          = try(module.server[0].tags_all, tomap({ "" = "" }))
  }
  # type = object({
  #   id                                = string
  #   arn                               = string
  #   ami                               = string
  #   type                              = string
  #   vpc                               = string
  #   subnet                            = string
  #   availability_zone                 = string
  #   security_group_ids                = list(string)
  #   key_name                          = string
  #   private_ip                        = string
  #   public_ip                         = string
  #   public_dns                        = string
  #   subnet_id                         = string
  #   ipv6_addresses                    = list(string)
  #   primary_network_interface_id      = string
  #   root_volume_id                    = string
  #   root_volume_size                  = string
  #   root_volume_tags                  = map(string)
  #   root_volume_encrypted             = bool
  #   root_volume_delete_on_termination = bool
  #   user_data_base64                  = string
  #   user_data_replace_on_change       = bool
  #   instance_state                    = string
  #   shutdown_behavior                 = string
  #   volume_tags                       = map(string)
  #   tags_all                          = map(string)
  # })
  description = "The server resource."
}
output "image" {
  value = {
    id          = try(module.image[0].id, "")
    user        = try(module.image[0].user, "")
    admin_group = try(module.image[0].admin_group, "")
    workfolder  = try(module.image[0].workfolder, "")
  }
  # type = object({
  #   id          = string
  #   user        = string
  #   admin_group = string
  #   workfolder  = string
  # })
  description = "The image resource."
}

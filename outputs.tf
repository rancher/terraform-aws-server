output "public_ip" {
  value = (local.add_eip ? module.direct_access[0].eip.public_ip : module.server[0].public_ip)
}

output "server" {
  value = (local.server_mod == 1 ? module.server[0].server : {
    id                          = ""
    ami                         = ""
    arn                         = ""
    associate_public_ip_address = false
    availability_zone           = ""
    credit_specification = tolist([{
      cpu_credits = ""
    }])
    capacity_reservation_specification = tolist([{
      capacity_reservation_preference = ""
      capacity_reservation_target = tolist([{
        capacity_reservation_id                 = ""
        capacity_reservation_resource_group_arn = ""
      }])
    }])
    cpu_core_count = 0
    cpu_options = tolist([{
      core_count       = 0
      threads_per_core = 0
      amd_sev_snp      = ""
    }])
    cpu_threads_per_core    = 0
    disable_api_stop        = false
    disable_api_termination = false
    ebs_block_device = toset([{
      device_name           = ""
      delete_on_termination = true
      encrypted             = false
      iops                  = 0
      kms_key_id            = ""
      snapshot_id           = ""
      tags                  = tomap({ "" = "" })
      tags_all              = tomap({ "" = "" })
      throughput            = 0
      volume_id             = ""
      volume_size           = 0
      volume_type           = ""
    }])
    ebs_optimized = false
    enclave_options = tolist([{
      enabled = false
    }])
    ephemeral_block_device = toset([{
      device_name  = ""
      no_device    = false
      virtual_name = ""
    }])
    get_password_data                    = false
    hibernation                          = false
    host_id                              = ""
    host_resource_group_arn              = ""
    iam_instance_profile                 = ""
    instance_state                       = ""
    instance_type                        = ""
    instance_initiated_shutdown_behavior = ""
    instance_lifecycle                   = ""
    instance_market_options = tolist([{
      market_type = ""
      spot_options = tolist([{
        instance_interruption_behavior = ""
        max_price                      = ""
        spot_instance_type             = ""
        valid_until                    = ""
      }])
    }])
    ipv6_address_count = 0
    ipv6_addresses     = tolist([""])
    key_name           = ""
    launch_template = tolist([{
      id      = ""
      name    = ""
      version = ""
    }])
    metadata_options = tolist([{
      http_endpoint               = ""
      http_put_response_hop_limit = 0
      http_tokens                 = ""
      http_protocol_ipv6          = ""
      instance_metadata_tags      = ""
    }])
    monitoring = false
    maintenance_options = tolist([{
      auto_recovery = ""
    }])
    network_interface = toset([{
      delete_on_termination = true
      device_index          = 0
      network_interface_id  = ""
      network_card_index    = 0
    }])
    outpost_arn                  = ""
    password_data                = ""
    placement_group              = ""
    placement_partition_number   = 0
    primary_network_interface_id = ""
    private_dns                  = ""
    private_dns_name_options = tolist([{
      hostname_type                        = ""
      enable_resource_name_dns_a_record    = false
      enable_resource_name_dns_aaaa_record = false
    }])
    private_ip = ""
    public_dns = ""
    public_ip  = ""
    root_block_device = tolist([{
      device_name           = ""
      delete_on_termination = true
      encrypted             = false
      iops                  = 0
      kms_key_id            = ""
      tags                  = tomap({ "" = "" })
      tags_all              = tomap({ "" = "" })
      throughput            = 0
      volume_id             = ""
      volume_size           = 0
      volume_type           = ""
    }])
    secondary_private_ips    = toset([""])
    security_groups          = toset([""])
    source_dest_check        = true
    spot_instance_request_id = ""
    subnet_id                = ""
    tags                     = tomap({ "" = "" })
    tags_all                 = tomap({ "" = "" })
    tenancy                  = ""
    timeouts = {
      read   = ""
      create = ""
      update = ""
      delete = ""
    }
    user_data                   = ""
    user_data_base64            = ""
    user_data_replace_on_change = false
    volume_tags                 = tomap({ "" = "" })
    vpc_security_group_ids      = toset([""])
  })
}

output "image" {
  value = (local.image_mod == 1 ? module.image[0].ami : {
    id           = ""
    arn          = ""
    name         = ""
    architecture = ""
    boot_mode    = ""
    block_device_mappings = toset([{
      device_name  = ""
      ebs          = tomap({ "" = "" })
      no_device    = ""
      virtual_name = ""
    }])
    creation_date    = ""
    deprecation_time = ""
    description      = ""
    ena_support      = false
    hypervisor       = ""
    executable_users = tolist([""])
    filter = toset([{
      name   = ""
      values = toset([""])
    }])
    image_id           = ""
    include_deprecated = false
    most_recent        = false
    image_location     = ""
    image_owner_alias  = ""
    image_type         = ""
    imds_support       = ""
    kernel_id          = ""
    owner_id           = ""
    platform           = ""
    platform_details   = ""
    product_codes = toset([{
      product_code_id   = ""
      product_code_type = ""
    }])
    public              = false
    ramdisk_id          = ""
    root_snapshot_id    = ""
    name_regex          = ""
    owners              = tolist([""])
    root_device_name    = ""
    root_device_type    = ""
    sriov_net_support   = ""
    state               = ""
    state_reason        = tomap({ "" = "" })
    tpm_support         = ""
    usage_operation     = ""
    virtualization_type = ""
    tags                = tomap({ "" = "" })
    timeouts = {
      read = ""
    }
  })
}

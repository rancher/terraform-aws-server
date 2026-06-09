locals {
  # image
  image_use_strategy = var.image_use_strategy
  image              = var.image
  image_dummy = {
    id          = "dummy"
    user        = "dummy"
    admin_group = "dummy"
    workfolder  = "dummy"
  }
  server_image = (local.image == null ? local.image_dummy : local.image)
  # when finding an image you must specify an image_type from our list of supported image types (see module/image/types.tf)
  image_type = var.image_type

  # server
  server_use_strategy = var.server_use_strategy
  server_id           = var.server_id
  server_name         = var.server_name
  server_type         = var.server_type
  server_ip_family    = var.server_ip_family

  # internal access
  server_subnet_name         = var.subnet_name
  server_security_group_name = var.security_group_name
  server_private_ip          = var.private_ip # if this is empty AWS will assign one

  # balanced access
  indirect_access_use_strategy = var.indirect_access_use_strategy
  load_balancer_target_groups  = var.load_balancer_target_groups

  # direct access
  direct_access_use_strategy = var.direct_access_use_strategy
  server_access_addresses    = var.server_access_addresses
  server_user                = var.server_user
  add_domain                 = var.add_domain
  domain_name                = var.domain_name
  domain_zone                = var.domain_zone
  add_eip                    = var.add_eip

  # config
  cloudinit_use_strategy = var.cloudinit_use_strategy
  user_init              = var.cloudinit_content
  default_init = (local.direct_access_use_strategy == "ssh" ? templatefile("${path.module}/cloudinit.tpl", {
    user        = local.server_user.user
    image_user  = module.image[0].image.user
    admin_group = module.image[0].image.admin_group
    ssh_key     = local.server_user.public_ssh_key
    name        = local.server_name
    workfolder  = module.image[0].image.workfolder
  }) : "")

  # mods
  image_mod    = (local.image_use_strategy == "skip" ? 0 : 1)
  server_mod   = ((local.server_use_strategy == "skip" || local.image_mod == 0) ? 0 : 1)
  indirect_mod = ((local.indirect_access_use_strategy == "skip" || local.image_mod == 0 || local.server_mod == 0) ? 0 : 1)
  direct_mod   = ((local.direct_access_use_strategy == "skip" || local.image_mod == 0 || local.server_mod == 0) ? 0 : 1)
}

resource "terraform_data" "input_validation" {
  lifecycle {
    precondition {
      condition     = !(local.image_use_strategy == "select" && local.image == null)
      error_message = "missing_image: The image object must be provided when image_use_strategy is 'select'."
    }
    precondition {
      condition     = !(local.image_use_strategy == "find" && local.image_type == "")
      error_message = "missing_image_type: The image_type must be provided when image_use_strategy is 'find'."
    }
    precondition {
      condition     = !(local.server_use_strategy == "select" && local.server_id == "")
      error_message = "missing_server_id: The server_id must be provided when server_use_strategy is 'select'."
    }
    precondition {
      condition     = !(local.server_use_strategy == "create" && local.server_name == "")
      error_message = "missing_server_name: The server_name must be provided when server_use_strategy is 'create'."
    }
    precondition {
      condition     = !(local.server_use_strategy == "create" && local.server_type == "")
      error_message = "missing_server_type: The server_type must be provided when server_use_strategy is 'create'."
    }
    precondition {
      condition     = !(local.server_use_strategy == "create" && local.server_subnet_name == "")
      error_message = "missing_subnet_name: The subnet_name must be provided when server_use_strategy is 'create'."
    }
    precondition {
      condition     = !(local.server_use_strategy == "create" && local.server_security_group_name == "")
      error_message = "missing_security_group_name: The security_group_name must be provided when server_use_strategy is 'create'."
    }
    precondition {
      condition     = !(local.indirect_access_use_strategy == "create" && length(local.load_balancer_target_groups) > 0)
      error_message = "missing_load_balancer_target_groups: Target groups must be provided when indirect_access_use_strategy is 'create'."
    }
    precondition {
      condition     = !(local.direct_access_use_strategy != "skip" && local.server_access_addresses == null)
      error_message = "missing_server_access_addresses: Server access addresses must be provided when direct_access_use_strategy is not 'skip'."
    }
    precondition {
      condition     = !(local.direct_access_use_strategy == "ssh" && local.server_user == null)
      error_message = "missing_server_user: The server_user object must be provided when direct_access_use_strategy is 'ssh'."
    }
    precondition {
      condition     = !(local.add_domain && local.domain_name == "")
      error_message = "missing_domain_name: The domain_name must be provided when add_domain is true."
    }
    precondition {
      condition     = !(local.add_domain && local.domain_zone == "")
      error_message = "missing_domain_zone: The domain_zone must be provided when add_domain is true."
    }
    precondition {
      condition     = !(local.cloudinit_use_strategy == "specify" && local.user_init == "")
      error_message = "missing_cloudinit: The cloudinit_content must be provided when cloudinit_use_strategy is 'specify'."
    }
    precondition {
      condition     = !(local.cloudinit_use_strategy == "default" && local.direct_access_use_strategy != "ssh")
      error_message = "direct_access_incorrect_for_default_cloudinit: direct_access_use_strategy must be 'ssh' to use 'default' cloudinit."
    }
  }
}

module "image" {
  count        = local.image_mod
  source       = "./modules/image"
  use_strategy = local.image_use_strategy
  type         = local.image_type
  image        = local.server_image
}

data "cloudinit_config" "setup" {
  depends_on = [
    module.image,
  ]
  count         = (local.cloudinit_use_strategy == "skip" ? 0 : 1)
  gzip          = false
  base64_encode = true
  part {
    filename     = "cloudinit"
    content_type = "text/cloud-config"
    content      = (local.cloudinit_use_strategy == "default" ? local.default_init : local.user_init)
  }
}

module "server" {
  count = local.server_mod
  depends_on = [
    module.image
  ]
  source                   = "./modules/server"
  use                      = local.server_use_strategy
  id                       = local.server_id
  name                     = local.server_name
  type                     = local.server_type
  ip_family                = local.server_ip_family
  image                    = module.image[0].image
  image_supports_c8        = try(module.image[0].types[local.image_type].supports_c8, false)
  image_supports_c7        = try(module.image[0].types[local.image_type].supports_c7, false)
  subnet                   = local.server_subnet_name
  security_group           = local.server_security_group_name
  ip                       = local.server_private_ip
  cloudinit                = (length(data.cloudinit_config.setup) > 0 ? data.cloudinit_config.setup[0].rendered : "")
  aws_keypair_use_strategy = (local.direct_access_use_strategy == "ssh" ? local.server_user.aws_keypair_use_strategy : "skip")
  ssh_key_name             = (local.direct_access_use_strategy == "ssh" ? local.server_user.ssh_key_name : "")
  ssh_key                  = (local.direct_access_use_strategy == "ssh" ? local.server_user.public_ssh_key : "")
}

module "indirect_access" {
  count = local.indirect_mod
  depends_on = [
    module.image,
    module.server,
  ]
  source             = "./modules/indirect_access"
  server_id          = module.server[0].id
  target_group_names = local.load_balancer_target_groups
}

module "direct_access" {
  count = local.direct_mod
  depends_on = [
    module.image,
    module.server,
    module.indirect_access,
  ]
  source = "./modules/direct_access"
  server = {
    id                   = module.server[0].id
    name                 = module.server[0].tags_all.Name
    network_interface_id = module.server[0].network_interface_id
    public_ip            = module.server[0].public_ip
    vpc_id               = module.server[0].vpc_id
  }
  image = {
    id          = module.image[0].id
    user        = module.image[0].user
    admin_group = module.image[0].admin_group
    workfolder  = module.image[0].workfolder
  }
  use_strategy     = local.direct_access_use_strategy # 'network' or 'ssh'
  cloudinit_ignore = (local.cloudinit_use_strategy == "skip" ? true : false)
  access_addresses = local.server_access_addresses
  ssh              = local.server_user
  add_eip          = local.add_eip # EIP will automatically be added to domain records
  add_domain       = local.add_domain
  domain = {
    name = local.domain_name,
    zone = local.domain_zone, # zone name
    type = "A"                # we will enable ipv6 in the future
    ips  = distinct([module.server[0].public_ip, module.server[0].private_ip])
  }
  server_security_group_name = local.server_security_group_name
}

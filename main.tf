locals {
  # image
  image_use_strategy = var.image_use_strategy
  image              = var.image
  # tflint-ignore: terraform_unused_declarations
  fail_image = ((local.image_use_strategy == "select" && local.image == null) ? one([local.image, "missing_image"]) : false)
  image_dummy = {
    id          = "dummy"
    user        = "dummy"
    admin_group = "dummy"
    workfolder  = "dummy"
  }
  server_image = (local.image == null ? local.image_dummy : local.image)
  # when finding an image you must specify an image_type from our list of supported image types (see module/image/types.tf)
  image_type = var.image_type
  # tflint-ignore: terraform_unused_declarations
  fail_image_type = ((local.image_use_strategy == "find" && local.image_type == "") ? one([local.image_type, "missing_image_type"]) : false)

  # server
  server_use_strategy = var.server_use_strategy
  server_id           = var.server_id
  # tflint-ignore: terraform_unused_declarations
  fail_server_id = ((local.server_use_strategy == "select" && local.server_id == "") ? one([local.server_id, "missing_server_id"]) : false)
  server_name    = var.server_name
  # tflint-ignore: terraform_unused_declarations
  fail_server_name = ((local.server_use_strategy == "create" && local.server_name == "") ? one([local.server_name, "missing_server_name"]) : false)
  server_type      = var.server_type
  # tflint-ignore: terraform_unused_declarations
  fail_server_type = ((local.server_use_strategy == "create" && local.server_type == "") ? one([local.server_type, "missing_server_type"]) : false)

  # internal access
  server_subnet_name = var.subnet_name
  # tflint-ignore: terraform_unused_declarations
  fail_subnet_name           = ((local.server_use_strategy == "create" && local.server_subnet_name == "") ? one([local.server_subnet_name, "missing_subnet_name"]) : false)
  server_security_group_name = var.security_group_name
  # tflint-ignore: terraform_unused_declarations
  fail_security_group_name = ((local.server_use_strategy == "create" && local.server_security_group_name == "") ? one([local.server_security_group_name, "missing_security_group_name"]) : false)
  server_private_ip        = var.private_ip # if this is empty we will select one

  # balanced access
  indirect_access_use_strategy = var.indirect_access_use_strategy
  load_balancer_target_groups  = var.load_balancer_target_groups
  # tflint-ignore: terraform_unused_declarations
  fail_load_balancer_target_groups = ((local.indirect_access_use_strategy == "create" && length(local.load_balancer_target_groups) > 0) ? one([local.load_balancer_target_groups, "missing_load_balancer_target_groups"]) : false)

  # direct access
  direct_access_use_strategy = var.direct_access_use_strategy
  server_access_addresses    = var.server_access_addresses
  # tflint-ignore: terraform_unused_declarations
  fail_server_access_addresses = ((local.direct_access_use_strategy != "skip" && local.server_access_addresses == null) ? one([local.server_access_addresses, "missing_server_access_addresses"]) : false)
  server_user                  = var.server_user
  # tflint-ignore: terraform_unused_declarations
  fail_server_user = ((local.direct_access_use_strategy == "ssh" && local.server_user == null) ? one([local.server_user, "missing_server_user"]) : false)
  add_domain       = var.add_domain
  domain_name      = var.domain_name
  # tflint-ignore: terraform_unused_declarations
  fail_domain_name = ((local.add_domain && local.domain_name == "") ? one([local.domain_name, "missing_domain_name"]) : false)
  domain_zone      = var.domain_zone
  # tflint-ignore: terraform_unused_declarations
  fail_domain_zone      = ((local.add_domain && local.domain_zone == "") ? one([local.domain_zone, "missing_domain_zone"]) : false)
  add_eip               = var.add_eip
  direct_access_host_ip = (length(module.server) > 0 ? module.server[0].public_ip : "")
  # tflint-ignore: terraform_unused_declarations
  fail_direct_access_host_ip = ((local.server_mod == 1 && local.direct_access_use_strategy != "skip" && local.direct_access_host_ip == "") ? one([local.direct_access_host_ip, "missing_direct_access_host_ip"]) : false)

  # config
  cloudinit_use_strategy = var.cloudinit_use_strategy
  user_init              = var.cloudinit_content
  default_init = (local.direct_access_use_strategy == "ssh" ? templatefile("${path.module}/cloudinit.tpl", {
    user        = local.server_user.user
    image_user  = module.image[0].image.user
    admin_group = module.image[0].image.admin_group
    ssh_key     = local.server_user.public_ssh_key
    name        = local.server_name
  }) : "")
  # tflint-ignore: terraform_unused_declarations
  fail_cloudinit_specify = ((local.cloudinit_use_strategy == "specify" && local.user_init == "" ? one([local.user_init, "missing_cloudinit"]) : false))
  # tflint-ignore: terraform_unused_declarations
  fail_cloudinit_default = ((local.cloudinit_use_strategy == "default" && local.direct_access_use_strategy != "ssh" ? one([local.direct_access_use_strategy, "direct_access_incorrect_for_default_cloudinit"]) : false))

  # mods
  image_mod    = (local.image_use_strategy == "skip" ? 0 : 1)
  server_mod   = ((local.server_use_strategy == "skip" || local.image_mod == 0) ? 0 : 1)
  indirect_mod = ((local.indirect_access_use_strategy == "skip" || local.image_mod == 0 || local.server_mod == 0) ? 0 : 1)
  direct_mod   = ((local.direct_access_use_strategy == "skip" || local.image_mod == 0 || local.server_mod == 0) ? 0 : 1)
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
  image                    = module.image[0].image
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
    ips  = [module.server[0].public_ip, module.server[0].private_ip]
  }
}

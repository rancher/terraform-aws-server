locals {
  image_id           = var.image_id
  image_type         = var.image
  image_initial_user = var.image_initial_user
  image_admin_group  = var.image_admin_group
  image_workfolder   = var.image_workfolder

  server_id                  = var.id
  server_name                = var.name
  server_owner               = var.owner
  server_type                = var.type
  server_user                = var.user
  server_skip_key            = var.skip_key
  server_ssh_key             = var.ssh_key
  server_ssh_key_name        = var.ssh_key_name
  server_security_group_name = var.security_group_name
  server_private_ip          = var.private_ip
  server_eip                 = var.add_public_ip

  security_group_association_force_create = var.security_group_association_force_create
  disable_scripts                         = var.disable_scripts

  server_subnet_name       = var.subnet_name
  server_cloudinit_script  = var.cloudinit_script
  server_cloudinit_timeout = var.cloudinit_timeout

  skip_server = ((local.server_id == "" && local.server_name == "") ? true : false)
}

# image module can't be skipped, but it can select an image based on the image_id rather than the image variable
module "image" {
  source       = "./modules/image"
  id           = local.image_id
  type         = local.image_type
  initial_user = local.image_initial_user
  admin_group  = local.image_admin_group
  workfolder   = local.image_workfolder
}

module "server" {
  count = (local.skip_server ? 0 : 1)
  depends_on = [
    module.image
  ]
  source             = "./modules/server"
  id                 = local.server_id
  name               = local.server_name
  owner              = local.server_owner
  type               = local.server_type
  user               = local.server_user
  image_id           = module.image.id
  image_admin_group  = module.image.admin_group
  image_initial_user = module.image.initial_user
  image_workfolder   = module.image.workfolder
  ssh_key            = local.server_ssh_key
  ssh_key_name       = local.server_ssh_key_name
  skip_key           = local.server_skip_key
  security_group     = local.server_security_group_name
  subnet             = local.server_subnet_name
  ip                 = local.server_private_ip
  eip                = local.server_eip
  cloudinit_script   = local.server_cloudinit_script
  cloudinit_timeout  = local.server_cloudinit_timeout

  security_group_association_force_create = local.security_group_association_force_create
  disable_scripts                         = local.disable_scripts
}

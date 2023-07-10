locals {
  image_id           = var.image_id
  image_type         = var.image
  image_initial_user = var.image_initial_user
  image_admin_group  = var.image_admin_group

  server_id                  = var.server_id
  server_name                = var.server_name
  server_owner               = var.server_owner
  server_type                = var.server_type
  server_user                = var.server_user
  server_ssh_key             = var.server_ssh_key
  server_security_group_name = var.server_security_group_name
  server_subnet_name         = var.server_subnet_name

  skip_server = ((local.server_id == "" && local.server_name == "") ? true : false)
  skip_image  = (local.image_id != "" ? true : false)
}

module "image" {
  count        = local.skip_image ? 0 : 1
  source       = "./modules/image"
  id           = local.image_id
  type         = local.image_type
  initial_user = local.image_initial_user
  admin_group  = local.image_admin_group
}

module "server" {
  count = local.skip_server ? 0 : 1
  depends_on = [
    module.image
  ]
  source             = "./modules/server"
  id                 = local.server_id
  name               = local.server_name
  owner              = local.server_owner
  type               = local.server_type
  user               = local.server_user
  image_id           = (local.skip_image ? local.image_id : module.image[0].id)
  image_admin_group  = (local.skip_image ? local.image_admin_group : module.image[0].admin_group)
  image_initial_user = (local.skip_image ? local.image_initial_user : module.image[0].initial_user)
  ssh_key            = local.server_ssh_key
  security_group     = local.server_security_group_name
  subnet             = local.server_subnet_name
}

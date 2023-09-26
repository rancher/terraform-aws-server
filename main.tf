locals {
  image_id           = var.image_id
  image_type         = var.image
  image_initial_user = var.image_initial_user
  image_admin_group  = var.image_admin_group

  server_id                  = var.id
  server_name                = var.name
  server_owner               = var.owner
  server_type                = var.type
  server_user                = var.user
  server_ssh_key             = var.ssh_key
  server_security_group_name = var.security_group_name
  server_subnet_name         = var.subnet_name
  server_az                  = var.availability_zone

  skip_server = ((local.server_id == "" && local.server_name == "") ? true : false)
}

# image module can't be skipped, but it can select an image based on the image_id rather than the image variable
module "image" {
  source       = "./modules/image"
  id           = local.image_id
  type         = local.image_type
  initial_user = local.image_initial_user
  admin_group  = local.image_admin_group
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
  ssh_key            = local.server_ssh_key
  security_group     = local.server_security_group_name
  subnet             = local.server_subnet_name
  availability_zone  = local.server_az
}

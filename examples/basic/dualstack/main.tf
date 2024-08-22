provider "aws" {
  default_tags {
    tags = {
      Id    = local.identifier
      Owner = local.email
    }
  }
}

locals {
  identifier   = var.identifier # this is a random unique string that can be used to identify resources in the cloud provider
  category     = "basic"
  example      = "dualstack"
  email        = "terraform-ci@suse.com"
  project_name = trimsuffix(substr("tf-${local.identifier}-${substr(md5(join("-", [local.category, local.example, md5(local.identifier)])), 0, 5)}", 0, 25), "-")
  image        = "sles-15"
  username     = lower(substr("tf-${local.identifier}", 0, 25))
  ip           = chomp(data.http.myip.response_body)
  ssh_key      = var.key
}

data "http" "myip" {
  url = "https://ipinfo.io/ip"
  retry {
    attempts     = 2
    min_delay_ms = 1000
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_pet" "server" {
  keepers = {
    # regenerate the pet name when the identifier changes
    identifier = local.identifier
  }
  length = 1
}

module "access" {
  source              = "rancher/access/aws"
  version             = "v3.1.4"
  vpc_name            = substr("vpc-${local.project_name}", 0, 32)
  vpc_type            = "dualstack"
  security_group_name = substr("secg-${local.project_name}", 0, 32)
  security_group_type = "project"
  load_balancer_name  = substr("lb-${local.project_name}", 0, 32)
  domain_use_strategy = "skip"
  vpc_public          = true
}


module "this" {
  depends_on = [
    module.access,
  ]
  source = "../../../" # change this to "rancher/server/aws" per https://registry.terraform.io/modules/rancher/server/aws/latest
  # version = "v1.1.1" # when using this example you will need to set the version
  image_type                 = local.image
  server_name                = substr("${local.project_name}-${random_pet.server.id}", 0, 32)
  server_type                = "small"
  subnet_name                = keys(module.access.subnets)[0]
  server_ip_family           = "dualstack"
  security_group_name        = module.access.security_group.tags_all.Name
  direct_access_use_strategy = "ssh"     # either the subnet needs to be public or you must add an eip
  cloudinit_use_strategy     = "default" # use the default cloudinit config
  server_access_addresses = {            # you must include ssh access here to enable setup
    "runner" = {
      port      = 22
      protocol  = "tcp"
      ip_family = "ipv4"
      cidrs     = ["${local.ip}/32"]
    }
  }
  server_user = {
    user                     = local.username
    aws_keypair_use_strategy = "skip"        # we will use cloud-init to add a keypair directly
    ssh_key_name             = ""            # not creating or selecting a key, but this field is still required
    public_ssh_key           = local.ssh_key # ssh key to add via cloud-init
    user_workfolder          = "/home/${local.username}"
    timeout                  = 5
  }
}

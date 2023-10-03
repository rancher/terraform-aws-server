locals {
  types = {
    sles-15 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "suse-sles-15-sp5-v*-hvm-*",
      owner        = "amazon",
      architecture = "x86_64",
    },
    sles-15-cis = { # WARNING! this AMI requires subscription to a service, it is not free
      user         = "ec2-user",
      group        = "wheel",
      name         = "CIS SUSE Linux Enterprise 15*",
      owner        = "aws-marketplace",
      architecture = "x86_64",
    },
    ubuntu-20 = { # WARNING! you must subscribe and accept the terms to use this image
      user         = "ubuntu",
      group        = "admin",
      name         = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-*",
      owner        = "aws-marketplace",
      architecture = "x86_64",
    },
    ubuntu-22 = { # WARNING! you must subscribe and accept the terms to use this image
      user         = "ubuntu",
      group        = "admin",
      name         = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-*",
      owner        = "aws-marketplace",
      architecture = "x86_64",
    },
    rhel-8 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "RHEL-8*_HVM-*-x86_64-*",
      owner        = "amazon",
      architecture = "x86_64",
    },
    rocky-8 = { # WARNING! you must subscribe and accept the terms to use this image
      user         = "ec2-user",
      group        = "wheel",
      name         = "Rocky-8-EC2-Base-8*",
      owner        = "aws-marketplace",
      architecture = "x86_64",
    },
    rhel-9 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "RHEL-9*_HVM-*-x86_64-*",
      owner        = "amazon",
      architecture = "x86_64",
    },
  }
}

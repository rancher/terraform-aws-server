locals {
  types = {
    sles-15 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "suse-sles-15-sp5-v*-hvm-*",
      owner        = "amazon",
      architecture = "x86_64",
      workfolder   = "~"
    },
    sles-15-cis = { # WARNING! this AMI requires subscription to a service, it is not free
      user         = "ec2-user",
      group        = "wheel",
      name         = "CIS SUSE Linux Enterprise 15*",
      owner        = "aws-marketplace",
      architecture = "x86_64",
      workfolder   = "~"
    },
    rhel-8-cis = { # WARNING! this AMI requires subscription to a service, it is not free https://aws.amazon.com/marketplace/server/procurement?productId=ca1fe94d-9237-41c7-8fc8-78b6b0658c9f
      user         = "ec2-user",
      group        = "wheel",
      name         = "CIS Red Hat Enterprise Linux 8 STIG Benchmark*",
      owner        = "aws-marketplace",
      architecture = "x86_64",
      workfolder   = "/var/tmp"
    },
    ubuntu-20 = { # WARNING! you must subscribe and accept the terms to use this image
      user         = "ubuntu",
      group        = "admin",
      name         = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-*",
      owner        = "aws-marketplace",
      architecture = "x86_64",
      workfolder   = "~"
    },
    ubuntu-22 = { # WARNING! you must subscribe and accept the terms to use this image
      user         = "ubuntu",
      group        = "admin",
      name         = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-*",
      owner        = "aws-marketplace",
      architecture = "x86_64",
      workfolder   = "~"
    },
    rhel-8 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "RHEL-8*_HVM-*-x86_64-*",
      owner        = "amazon",
      architecture = "x86_64",
      workfolder   = "~"
    },
    rocky-8 = { # WARNING! you must subscribe and accept the terms to use this image
      user         = "ec2-user",
      group        = "wheel",
      name         = "Rocky-8-EC2-Base-8*",
      owner        = "aws-marketplace",
      architecture = "x86_64",
      workfolder   = "~"
    },
    rhel-9 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "RHEL-9*_HVM-*-x86_64-*",
      owner        = "amazon",
      architecture = "x86_64",
      workfolder   = "~"
    },
  }
}

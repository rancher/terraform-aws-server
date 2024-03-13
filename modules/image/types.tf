locals {
  types = {
    sles-15 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "suse-sles-15-sp5-v2024*",
      owners       = ["013907871322", "679593333241"]
      architecture = "x86_64",
      workfolder   = "~"
    },
    sles-15-cis = { # WARNING! this AMI requires subscription to a service, it is not free
      user         = "ec2-user",
      group        = "wheel",
      name         = "CIS SUSE*15*",
      owners       = ["679593333241"],
      architecture = "x86_64",
      workfolder   = "~"
    },
    rhel-8-cis = { # WARNING! this AMI requires subscription to a service, it is not free https://aws.amazon.com/marketplace/server/procurement?productId=ca1fe94d-9237-41c7-8fc8-78b6b0658c9f
      user         = "ec2-user",
      group        = "wheel",
      name         = "CIS Red Hat*8*STIG*",
      owners       = ["679593333241"],
      architecture = "x86_64",
      workfolder   = "/var/tmp"
    },
    ubuntu-20 = { # WARNING! you must subscribe and accept the terms to use this image
      user         = "ubuntu",
      group        = "admin",
      name         = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-2024*-*-*-*-*-*",
      owners       = ["679593333241", "099720109477", "513442679011", "837727238323"],
      architecture = "x86_64",
      workfolder   = "~"
    },
    ubuntu-22 = { # WARNING! you must subscribe and accept the terms to use this image
      user         = "ubuntu",
      group        = "admin",
      name         = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-2024*-*-*-*-*-*",
      owners       = ["679593333241", "099720109477", "513442679011", "837727238323"],
      architecture = "x86_64",
      workfolder   = "~"
    },
    rocky-8 = { # WARNING! you must subscribe and accept the terms to use this image
      user         = "ec2-user",
      group        = "wheel",
      name         = "Rocky-8-*Base*.x86_64-*-*-*-*-*",
      owners       = ["679593333241"],
      architecture = "x86_64",
      workfolder   = "~"
    },
    # the goal for these search strings is to keep them as stable as possible without specifying a version that is EOL
    # our users often rely on extended support from RHEL, so we don't consider odd numbered minors which are inelegible for that
    # https://access.redhat.com/support/policy/updates/errata
    # therefore the search found here is the most recent even minor that has been released
    # expect RHEL 9.4 in June 2024
    rhel-9 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "RHEL-9.3*_HVM-2024*-x86_64-*-Hourly2-GP3",
      owners       = ["309956199498"],
      architecture = "x86_64",
      workfolder   = "~"
    },
    # following the same lines as rhel-9 this will be the most recent even minor that has been released
    # expect RHEL 8.10 in June 2024
    rhel-8 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "RHEL-8.9*_HVM-2024*-x86_64-*-Hourly2-GP3",
      owners       = ["309956199498"],
      architecture = "x86_64",
      workfolder   = "~"
    },
  }
}

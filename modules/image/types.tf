locals {
  standard_types = {
    # using the getImages script in this directory with argument "sles-15-sp5-chost"
    # suse-sles-15-sp5-chost-byos-v20240502-hvm-ssd-x86_64
    sles-15 = { # BYOS = Bring Your Own Subscription
      user         = "ec2-user",
      group        = "wheel",
      name         = "suse-sles-15-sp5-chost-byos-v*-hvm-ssd-x86_64",        #chost refers to an image that is optimized for running containers
      name_regex   = "^suse-sles-15-sp5-chost-byos-v[0-9]+-hvm-ssd-x86_64$", # we are specifically trying to avoid the -ecs- images
      product_code = "",
      owners       = ["013907871322"],
      architecture = "x86_64",
      workfolder   = "~"
    },
    # using the getImages script in this directory with argument "sle-micro-5-5-byos"
    # suse-sle-micro-5-5-byos-v20240113-hvm-ssd-x86_64
    # sle micro is already optimized for containers
    sle-micro-55 = { # BYOS = Bring Your Own Subscription
      user         = "suse",
      group        = "wheel",
      name         = "suse-sle-micro-5-5-byos-v*-hvm-ssd-x86_64",
      name_regex   = "^suse-sle-micro-5-5-byos-v[0-9]+-hvm-ssd-x86_64$",
      product_code = "",
      owners       = ["013907871322"],
      architecture = "x86_64",
      workfolder   = "~"
    }
    # WARNING! you must subscribe and accept the terms to use this image
    # https://aws.amazon.com/marketplace/server/procurement?productId=ca1fe94d-9237-41c7-8fc8-78b6b0658c9f
    rhel-8-cis = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "CIS Red Hat Enterprise Linux 8*",
      name_regex   = ".*",
      product_code = "bysa8cc41lo4owixsmqw6v44f",
      owners       = ["679593333241"],
      architecture = "x86_64",
      workfolder   = "/var/tmp"
    },
    # WARNING! you must subscribe and accept the terms to use this image
    # https://aws.amazon.com/marketplace/pp/prodview-iftkyuwv2sjxi
    # example: ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220606-aced0818-eef1-427a-9e04-8ba38bada306
    ubuntu-20 = {
      user         = "ubuntu",
      group        = "admin",
      name         = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-2024*",
      name_regex   = "^ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-2024[0-9]+-.*$", # specifically avoiding .1 images eg. ubuntu-jammy-22.04-amd64-server-20240207.1-47489723-7305-4e22-8b22-b0d57054f216
      product_code = "a8jyynf4hjutohctm41o2z18m",
      owners       = ["679593333241"],
      architecture = "x86_64",
      workfolder   = "~"
    },
    # WARNING! you must subscribe and accept the terms to use this image
    # example: ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240501-47489723-7305-4e22-8b22-b0d57054f216
    ubuntu-22 = {
      user         = "ubuntu",
      group        = "admin",
      name         = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-2024*",
      name_regex   = "^ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-2024[0-9]+-.*$", # specifically avoiding .1 images eg. ubuntu-jammy-22.04-amd64-server-20240207.1-47489723-7305-4e22-8b22-b0d57054f216
      product_code = "47xbqns9xujfkkjt189a13aqe",
      owners       = ["679593333241"],
      architecture = "x86_64",
      workfolder   = "~"
    },
    rocky-8 = { # WARNING! you must subscribe and accept the terms to use this image
      user         = "ec2-user",
      group        = "wheel",
      name         = "Rocky-8-EC2-Base-*.x86_64-*",
      name_regex   = "^Rocky-8-EC2-Base-.*.x86_64-.*$",
      product_code = "",
      owners       = ["679593333241"],
      architecture = "x86_64",
      workfolder   = "~"
    },
    # https://pint.suse.com/?resource=images&search=liberty&state=active
    # example: suse-liberty-7-9-byos-v20240320-x86_64
    liberty-7 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "suse-liberty-7-9-byos-v*-x86_64",
      name_regex   = "^suse-liberty-7-9-byos-v[0-9]+-x86_64$",
      product_code = "",
      owners       = ["013907871322", "679593333241"],
      architecture = "x86_64",
      workfolder   = "~"
    },
    # following the same lines as rhel-9 this will be the most recent even minor that has been released
    # expect RHEL 8.10 in June 2024
    rhel-8 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "RHEL-8.9*_HVM-2024*-x86_64-*-Hourly2-GP3",
      name_regex   = "^RHEL-8.9.*_HVM-2024.*-x86_64-.*-Hourly2-GP3$",
      product_code = "",
      owners       = ["309956199498"],
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
      name_regex   = "^RHEL-9.3.*_HVM-2024.*-x86_64-.*-Hourly2-GP3$",
      product_code = "",
      owners       = ["309956199498"],
      architecture = "x86_64",
      workfolder   = "~"
    },
  }
}

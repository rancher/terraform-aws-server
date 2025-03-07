locals {
  # image search is only valid for regions in the regions.txt file in thie directory
  standard_types = {
    # using the getImages script in this directory with argument "sles"
    # suse-sles-15-sp6-chost-byos-v20250212-hvm-ssd-x86_64
    sles-15 = { # BYOS = Bring Your Own Subscription
      user         = "ec2-user",
      group        = "wheel",
      name         = "suse-sles-15-sp6-chost-byos-v*-hvm-ssd-x86_64",        #chost refers to an image that is optimized for running containers
      name_regex   = "^suse-sles-15-sp6-chost-byos-v[0-9]+-hvm-ssd-x86_64$", # we are specifically trying to avoid the -ecs- images
      product_code = "",
      owners       = ["013907871322"],
      architecture = "x86_64",
      workfolder   = "~"
    },

    # using the getImages script in this directory with argument "sle-micro"
    # suse-sle-micro-5-5-byos-v20250131-hvm-ssd-x86_64
    # sle micro is already optimized for containers
    sle-micro-55 = { # BYOS = Bring Your Own Subscription
      user         = "ec2-user",
      group        = "wheel",
      name         = "suse-sle-micro-5-5-byos-v*-hvm-ssd-x86_64",
      name_regex   = "^suse-sle-micro-5-5-byos-v[0-9]+-hvm-ssd-x86_64$",
      product_code = "",
      owners       = ["013907871322"],
      architecture = "x86_64",
      workfolder   = "~"
    }

    # using the getImages script in this directory with argument "sle-micro"
    # suse-sle-micro-6-0-byos-v20250210-hvm-ssd-x86_64
    # sle micro is already optimized for containers
    sle-micro-60 = { # BYOS = Bring Your Own Subscription
      user         = "suse",
      group        = "wheel",
      name         = "suse-sle-micro-6-0-byos-v*-hvm-ssd-x86_64",
      name_regex   = "^suse-sle-micro-6-0-byos-v[0-9]+-hvm-ssd-x86_64$",
      product_code = "",
      owners       = ["013907871322"],
      architecture = "x86_64",
      workfolder   = "~"
    }

    # using the getImages script in this directory with argument "sle-micro"
    # suse-sle-micro-6-1-byos-v20250210-hvm-ssd-x86_64
    # sle micro is already optimized for containers
    sle-micro-61 = { # BYOS = Bring Your Own Subscription
      user         = "suse",
      group        = "wheel",
      name         = "suse-sle-micro-6-1-byos-v*-hvm-ssd-x86_64",
      name_regex   = "^suse-sle-micro-6-1-byos-v[0-9]+-hvm-ssd-x86_64$",
      product_code = "",
      owners       = ["013907871322"],
      architecture = "x86_64",
      workfolder   = "~"
    }

    # WARNING! you must subscribe and accept the terms to use this image
    # https://aws.amazon.com/marketplace/server/procurement?productId=ca1fe94d-9237-41c7-8fc8-78b6b0658c9f
    # example: CIS Red Hat Enterprise Linux 8 Benchmark - STIG - v12 -ca1fe94d-9237-41c7-8fc8-78b6b0658c9f
    cis-rhel-8 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "CIS Red Hat Enterprise Linux 8 Benchmark - STIG*"
      name_regex   = ".*",
      product_code = "bysa8cc41lo4owixsmqw6v44f",
      owners       = ["679593333241"],
      architecture = "x86_64",
      workfolder   = "/var/tmp"
    },

    # WARNING! you must subscribe and accept the terms to use this image
    # ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20250305
    ubuntu-22 = {
      user         = "ubuntu",
      group        = "admin",
      name         = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*",
      name_regex   = "^ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-[0-9]+$", # specifically avoiding .1 images eg. ubuntu-jammy-22.04-amd64-server-20240207.1-47489723-7305-4e22-8b22-b0d57054f216
      product_code = "",                                                               #"47xbqns9xujfkkjt189a13aqe",
      owners       = ["099720109477"],
      architecture = "x86_64",
      workfolder   = "~"
    },

    # WARNING! you must subscribe and accept the terms to use this image
    # https://aws.amazon.com/marketplace/pp/prodview-a2hsmwr6uilqq
    # ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20250305
    ubuntu-24 = {
      user         = "ubuntu",
      group        = "admin",
      name         = "ubuntu-minimal/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-minimal-*",
      name_regex   = "^ubuntu-minimal/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-minimal-[0-9]+$",
      product_code = "",
      owners       = ["099720109477"],
      architecture = "x86_64",
      workfolder   = "~"
    },

    # WARNING! you must subscribe and accept the terms to use this image
    # https://aws.amazon.com/marketplace/pp/prodview-yjxmiuc6p5jzk
    # Rocky-9-EC2-LVM-9.5-20241118.0.x86_64-prod-hyj6jp3bki4bm
    rocky-9 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "Rocky-9-EC2-LVM-9.*-*.*.x86_64-prod-*",
      name_regex   = "^Rocky-9-EC2-LVM-9.[0-9]+-[0-9]+.[0-9].x86_64-prod-[0-9a-z]+$",
      product_code = "c0tjzp9xnxvr0ah4f0yletr6b",
      owners       = ["679593333241"],
      architecture = "x86_64",
      workfolder   = "~"
    },

    # the goal for these search strings is to keep them as stable as possible without specifying a version that is EOL
    # our users often rely on extended support from RHEL, so we don't consider odd numbered minors which are inelegible for that
    # https://access.redhat.com/support/policy/updates/errata
    # therefore the search found here is the most recent even minor that has been released
    # expect RHEL 9.4 in June 2024
    # RHEL-9.5.0_HVM-20241211-x86_64-0-Hourly2-GP3
    rhel-9 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "RHEL-9.*.*_HVM-*-x86_64-*-Hourly2-GP3",
      name_regex   = "^RHEL-9.[0-9].[0-9]_HVM-[0-9]+-x86_64-[0-9]-Hourly2-GP3$",
      product_code = "",
      owners       = ["309956199498"],
      architecture = "x86_64",
      workfolder   = "~"
    },

    # this is a community AMI with no product code or marketplace page, but it is produced by our cloud team
    # suse-liberty-linux-8-9-byos-v20240603-x86_64
    liberty-8 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "suse-liberty-linux-8-*-byos-v*-x86_64",
      name_regex   = "^suse-liberty-linux-8-[0-9]-byos-v[0-9]+-x86_64$",
      product_code = "",
      owners       = ["013907871322"],
      architecture = "x86_64",
      workfolder   = "~"
    },
  }
}

### DEPRECATED
## with the EOL of RHEL-7 and CentOS-7 in 2024, this image is no longer available
## # https://pint.suse.com/?resource=images&search=liberty&state=active
## # example: suse-liberty-7-9-byos-v20240320-x86_64
## liberty-7 = {
##   user         = "ec2-user",
##   group        = "wheel",
##   name         = "suse-liberty-7-9-byos-v*-x86_64",
##   name_regex   = "^suse-liberty-7-9-byos-v[0-9]+-x86_64$",
##   product_code = "",
##   owners       = ["013907871322", "679593333241"],
##  architecture = "x86_64",
##   workfolder   = "~"
## },
# with RHEL-8 being EOL we no longer support it, try rocky-8 or liberty-8 instead
# rhel-8 = {
#   user         = "ec2-user",
#   group        = "wheel",
#   name         = "RHEL-8.9*_HVM-2024*-x86_64-*-Hourly2-GP3",
#   name_regex   = "^RHEL-8.9.*_HVM-2024.*-x86_64-.*-Hourly2-GP3$",
#   product_code = "",
#   owners       = ["309956199498"],
#   architecture = "x86_64",
#   workfolder   = "~"
# },
# DEPRECATED! We no longer support Ubuntu 20.04
# WARNING! you must subscribe and accept the terms to use this image
# https://aws.amazon.com/marketplace/pp/prodview-iftkyuwv2sjxi
# example: ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220606-aced0818-eef1-427a-9e04-8ba38bada306
# ubuntu-20 = {
#   user         = "ubuntu",
#   group        = "admin",
#   name         = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-2024*",
#   name_regex   = "^ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-2024[0-9]+-.*$", # specifically avoiding .1 images eg. ubuntu-jammy-22.04-amd64-server-20240207.1-47489723-7305-4e22-8b22-b0d57054f216
#   product_code = "a8jyynf4hjutohctm41o2z18m",
#   owners       = ["679593333241"],
#   architecture = "x86_64",
#   workfolder   = "~"
# },
# We no longer support Rocky 8 in favor of liberty 8
# WARNING! you must subscribe and accept the terms to use this image
# https://aws.amazon.com/marketplace/pp/prodview-2otariyxb3mqu
# example: Rocky-8-EC2-Base-8.9-20231119.0.x86_64-d6577ceb-8ea8-4e0e-84c6-f098fc302e82
# rocky-8 = {
#   user         = "ec2-user",
#   group        = "wheel",
#   name         = "Rocky-8-EC2-Base-8.*-*.*.x86_64-*", # LVM is preferred, but Rocky 8 doesn't have an official LVM image
#   name_regex   = "^Rocky-8-EC2-Base-8.[0-9]+-[0-9]+.[0-9].x86_64-.*$",
#   product_code = "cotnnspjrsi38lfn8qo4ibnnm",
#   owners       = ["679593333241"],
#   architecture = "x86_64",
#   workfolder   = "~"
# },
